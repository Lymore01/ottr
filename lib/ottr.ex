defmodule Ottr do
  use GenServer
  require Logger
  alias Ottr.OttrRepo.Tasks
  alias Ottr.OttrRepo.Queues
  alias Ottr.OttrRepo.DeadLetters
  alias Ottr.Handlers.Handler

  # constants
  @flush_interval_ms 1_000
  @max_buffer_size 5
  @retry_limit 4
  @timeout_seconds 300

  # Client APIs
  def start_link(queue_name) do
    GenServer.start_link(__MODULE__, queue_name, name: via_tuple(queue_name))
  end

  # dynamically start a new queue (a genserver process)
  def create_queue(name) do
    case Queues.create_queue(name) do
      {:ok, _queue} ->
        Logger.info("Queue created: #{inspect(name)}")
        spec = {Ottr, name}
        DynamicSupervisor.start_child(TaskQueueSupervisor, spec)

      {:error, reason} ->
        {:error, reason}
    end
  end

  def insert(queue_name, task) when is_binary(task) do
    Logger.warning("Rejecting raw string task: #{inspect(task)} into #{inspect(queue_name)}")
    {:error, :invalid_task_format}
  end

  def insert(queue_name, %{data: %{"type" => _type, "args" => _args}} = task) do
    case Queues.get_queue_by_name(queue_name) do
      nil ->
        Logger.warning("Queue not found: #{queue_name}")
        {:error, :queue_not_found}

      _queue ->
        attrs = %{queue: queue_name, data: task.data, status: "pending"}

        case Tasks.create_task(attrs) do
          {:ok, db_task} ->
            GenServer.cast(
              via_tuple(queue_name),
              {:insert, %{id: db_task.id, data: task.data, retries: 0}}
            )

          {:error, reason} ->
            {:error, reason}
        end
    end
  end

  # for re-insertion
  def insert(queue_name, %{id: id, data: _data, retries: _retries} = task) do
    Tasks.update_task(Tasks.get_task!(id), %{
      retries: task.retries,
      status: "pending"
    })

    GenServer.cast(via_tuple(queue_name), {:insert, task})
  end

  def flush(queue_name) do
    GenServer.call(via_tuple(queue_name), :flush)
  end

  # get all tasks from a topic
  def get_all_tasks(queue_name) do
    GenServer.call(via_tuple(queue_name), :get_all_tasks)
  end

  # TODO: Remove this implementation
  def fetch_task(queue_name) do
    GenServer.call(via_tuple(queue_name), :fetch_task)
  end

  def ack_task(queue_name, task_id) do
    task = Tasks.get_task!(task_id)

    if task.status != "in_progress" do
      Logger.warning("Task #{task_id} is not in progress, cannot acknowledge.")
      {:error, :task_not_in_progress}
    else
      Tasks.update_task(task, %{status: "acknowledged", locked_at: nil})
      GenServer.cast(via_tuple(queue_name), {:ack_task, task_id})
      {:ok, task}
    end
  end

  # Server Callbacks
  # init function - sets up the state
  @impl true
  def init(queue_name) do
    Logger.info("Starting TaskQueue for #{queue_name}")
    tasks = Tasks.list_available_tasks_for_queue(queue_name, @timeout_seconds)
    timer = Process.send_after(self(), :tick, @flush_interval_ms)

    {:ok,
     %{queue_name: queue_name, buffer: tasks, in_progress: %{}, running_tasks: %{}, timer: timer}}
  end

  # handle_cast function - handles asynchronous messages
  @impl true
  def handle_cast({:insert, task}, %{buffer: buffer, timer: timer} = state) do
    new_buffer = [task | buffer]
    # If buffer size exceeds max, flush it
    if length(new_buffer) >= @max_buffer_size do
      Logger.info("Buffer full, flushing tasks...")
      Process.cancel_timer(timer)
      do_flush(state.queue_name, new_buffer)
      new_timer = Process.send_after(self(), :tick, @flush_interval_ms)
      # Reset the buffer after flushing
      {:noreply, %{state | buffer: [], timer: new_timer}}
    else
      {:noreply, %{state | buffer: new_buffer}}
    end
  end

  @impl true
  def handle_cast({:ack_task, task_id}, %{in_progress: in_progress} = state) do
    case Map.pop(in_progress, task_id) do
      {nil, _} ->
        Logger.warning("Ack received for unknown task: #{inspect(task_id)}")
        {:noreply, state}

      {_task, new_in_progress} ->
        Logger.info("Task acknowledged: #{inspect(task_id)}")
        {:noreply, %{state | in_progress: new_in_progress}}
    end
  end

  @impl true
  def handle_cast({:task_started, task_id, pid, ref}, state) do
    Logger.info("Task started: #{inspect(task_id)} with PID: #{inspect(pid)}")
    new_running = Map.put(state.running_tasks, task_id, {pid, ref})
    {:noreply, %{state | running_tasks: new_running}}
  end

  @impl true
  def handle_cast({:task_finished, task_id}, state) do
    Logger.info("Task finished: #{inspect(task_id)}")

    case Map.pop(state.running_tasks, task_id) do
      {{_pid, ref}, new_running} ->
        Process.demonitor(ref, [:flush])
        {:noreply, %{state | running_tasks: new_running}}

      {nil, _} ->
        Logger.warning("Task finished for unknown task id: #{inspect(task_id)}")
        {:noreply, state}
    end
  end

  @impl true
  def handle_call(:fetch_task, _from, %{buffer: [task | rest], in_progress: in_progress} = state) do
    now = DateTime.utc_now()
    Tasks.update_task(Tasks.get_task!(task.id), %{status: "in_progress", locked_at: now})
    new_in_progress = Map.put(in_progress, task.id, task)
    new_state = %{state | buffer: rest, in_progress: new_in_progress}
    {:reply, task, new_state}
  end

  @impl true
  def handle_call(:fetch_task, _from, %{buffer: [], in_progress: _in_progress} = state) do
    {:reply, nil, state}
  end

  # handle_call function - handles synchronous requests
  @impl true
  def handle_call(:flush, _from, %{buffer: buffer, timer: timer} = state) do
    Process.cancel_timer(timer)
    do_flush(state.queue_name, buffer)
    new_timer = Process.send_after(self(), :tick, @flush_interval_ms)
    {:reply, :ok, %{state | buffer: [], timer: new_timer}}
  end

  # get all tasks
  @impl true
  def handle_call(:get_all_tasks, _from, %{buffer: buffer} = state) do
    {:reply, buffer, state}
  end

  # handle_info function - handles periodic timer ticks
  @impl true
  def handle_info(:tick, %{buffer: buffer} = state) do
    do_flush(state.queue_name, buffer)
    new_timer = Process.send_after(self(), :tick, @flush_interval_ms)
    {:noreply, %{state | buffer: [], timer: new_timer}}
  end

  @impl true
  def handle_info({:retry_task, queue_name, task}, state) do
    GenServer.cast(via_tuple(queue_name), {:insert, task})
    {:noreply, state}
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _pid, _reason}, state) do
    # prevent double execution of the same task
    case Enum.find(state.running_tasks, fn {_task_id, {_pid, r}} -> r == ref end) do
      {task_id, _} ->
        Tasks.update_task(Tasks.get_task!(task_id), %{status: "pending", locked_at: nil})
        new_running = Map.delete(state.running_tasks, task_id)
        {:noreply, %{state | running_tasks: new_running}}

      nil ->
        Logger.debug("Received :DOWN for unknown or already cleaned up task.")
        {:noreply, state}
    end
  end

  # handle_info function - handles unexpected messages
  @impl true
  def handle_info(msg, state) do
    Logger.warning("Received unexpected message: #{inspect(msg)}")
    {:noreply, state}
  end

  # Private function to process the tasks in the buffer
  @impl true
  def terminate(_reason, %{buffer: buffer, timer: _timer} = state) do
    Logger.info("Flushing remaining tasks before shutdown...")
    do_flush(state.queue_name, buffer)
    :ok
  end

  # Private Methods

  # via_tuple function - creates a tuple for process lookup
  # This allows us to use the Registry to find the process by name
  defp via_tuple(name) do
    {:via, Registry, {TaskQueueRegistry, name}}
  end

  defp do_flush(_queue_name, []), do: :ok

  defp do_flush(queue_name, buffer) do
    :telemetry.execute([:ottr, :queue, :flush], %{count: length(buffer)}, %{queue: queue_name})

    Enum.each(buffer, fn task ->
      now = DateTime.utc_now()

      Tasks.update_task(Tasks.get_task!(task.id), %{
        status: "in_progress",
        locked_at: now
      })

      :poolboy.transaction(
        :task_worker_pool,
        fn pid ->
          ref = Process.monitor(pid)

          GenServer.cast(self(), {:task_started, task.id, pid, ref})

          send(
            pid,
            {:process,
             fn ->
               process_task(queue_name, task)
               GenServer.cast(via_tuple(queue_name), {:task_finished, task.id})
             end}
          )
        end
      )
    end)
  end

  # TODO: change it back to private function after tests
  def process_task(queue_name, %{data: %{"type" => type, "args" => args}} = task) do
    Logger.info("Processing task concurrently: #{inspect(task.data)}")

    start_time = System.monotonic_time()

    :telemetry.execute([:ottr, :task, :started], %{system_time: System.system_time()}, %{
      type: type,
      queue: queue_name
    })

    task_for_retry = %{task | data: task.data}

    handler = Handler.resolve_handler(type)

    case handler.handle(args) do
      :ok ->
        mark_done(task)

      {:done, completed_workflow} ->
        mark_done(task)

        duration =
          safe_diff_ms(completed_workflow.finished_at, completed_workflow.started_at)

        :telemetry.execute([:ottr, :workflow, :completed], %{duration: duration}, %{
          name: completed_workflow.name,
          queue: completed_workflow.queue,
          steps: length(completed_workflow.workflow_steps)
        })

      {:ok, _workflow} ->
        duration = System.monotonic_time() - start_time

        :telemetry.execute([:ottr, :task, :completed], %{duration: duration}, %{
          type: type,
          queue: queue_name
        })

        mark_done(task)

      {:error, reason} ->
        duration = System.monotonic_time() - start_time

        :telemetry.execute([:ottr, :task, :failed], %{duration: duration}, %{
          type: type,
          queue: queue_name,
          reason: inspect(reason)
        })

        Ottr.Schedulers.Retry.maybe_retry(
          task_for_retry,
          queue_name,
          @retry_limit,
          &via_tuple/1,
          Tasks,
          DeadLetters,
          reason
        )
    end
  end

  defp safe_diff_ms(%DateTime{} = finished, %DateTime{} = started) do
    seconds = DateTime.diff(finished, started, :second)
    milliseconds = seconds * 1_000
    milliseconds
  end

  defp safe_diff_ms(_, _), do: 0

  defp mark_done(task) do
    Logger.info("Task processed successfully: #{inspect(task.data)}")
    fetch_task = Tasks.get_task!(task.id)
    Tasks.update_task(fetch_task, %{status: "done", locked_at: nil})
  end
end
