defmodule Ottr.Retry do
  require Logger
  @base_delay 1_000

  def maybe_retry(
        task,
        queue_name,
        retry_limit,
        via_tuple,
        tasks_mod,
        dead_letter_mod,
        reason \\ "retry_limit_reached"
      ) do
    fetch_task = tasks_mod.get_task!(task.id)
    retries = Map.get(fetch_task, :retries, 0) + 1

    if retries < retry_limit do
      :telemetry.execute([:ottr, :task, :retry], %{retry: task.retries}, %{
        type: task.data["type"],
        queue: queue_name
      })

      tasks_mod.update_task(fetch_task, %{retries: retries, status: "pending", locked_at: nil})

      # exponential backoff formula
      delay = (@base_delay * :math.pow(2, retries - 1)) |> round()

      if pid = GenServer.whereis(via_tuple.(queue_name)) do
        Process.send_after(
          pid,
          {:retry_task, queue_name, %{task | retries: retries}},
          delay
        )
      else
        Logger.error("Could not retry task: queue process for #{queue_name} not found")
      end

      Logger.warning("Task failed, retrying: #{inspect(task.data)} (Attempt #{retries})")
      :retrying
    else
      :telemetry.execute([:ottr, :task, :dead_letter], %{}, %{
        task_id: task.id,
        type: task.data["args"],
        queue: queue_name
      })

      tasks_mod.update_task(fetch_task, %{status: "failed", locked_at: nil})
      dead_letter_mod.move_to_dead_letter(fetch_task, reason)
      Logger.error("Task failed after retries: #{inspect(task.data)}")
      :dead_lettered
    end
  end
end
