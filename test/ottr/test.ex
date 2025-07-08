ExUnit.start()

defmodule OttrTest do
  use ExUnit.Case, async: true

  @queue "test_queue"

  setup do
    # Ensure a clean state for each test
    Ottr.create_queue(@queue)

    :ok
  end

  test "create and fetch a task" do
    attrs = %{queue: @queue, data: %{"type" => "email_sender", "args" => %{
      "data" => "payload1"
    }}, status: "pending"}
    {:ok, task} = Ottr.OttrRepo.Tasks.create_task(attrs)
    task = Ottr.OttrRepo.Tasks.get_task(task.id)
    assert task.data["args"]["data"]   == "payload1"
    assert task.retries == 0
  end

  test "acknowledge a task" do
    :ok = Ottr.insert(@queue, %{data: %{"type" => "generic", "args" => ["payload2"]}})
    task = Ottr.fetch_task(@queue)
    assert {:ok, _} = Ottr.ack_task(@queue, task.id)
  end

  test "cannot acknowledge a task not in progress" do
    :ok = Ottr.insert(@queue, %{data: %{"type" => "generic", "args" => ["payload3"]}})
    [task] = Ottr.get_all_tasks(@queue)
    assert {:error, :task_not_in_progress} = Ottr.ack_task(@queue, task.id)
  end

  test "buffer flushes when max size is reached" do
    for i <- 1..5 do
      Ottr.insert(@queue, %{data: %{"type" => "generic", "args" => ["bulk#{i}"]}})
    end

    tasks = Enum.map(1..5, fn _ -> Ottr.fetch_task(@queue) end)
    assert Enum.count(tasks) == 5
  end

  test "task retry and failure after retry limit" do
    :ok = Ottr.insert(@queue, %{data: %{"type" => "generic", "args" => ["fail_me"]}})
    task = Ottr.fetch_task(@queue)

    Ottr.OttrRepo.Tasks.update_task(Ottr.OttrRepo.Tasks.get_task!(task.id), %{
      retries: 2,
      status: "in_progress"
    })

    # Assuming process_task/2 is available
    Ottr.process_task(@queue, task)

    db_task = Ottr.OttrRepo.Tasks.get_task!(task.id)
    assert db_task.status == "failed"
    dead_letter_tasks = Ottr.OttrRepo.DeadLetters.list_dead_letters()
    assert Enum.any?(dead_letter_tasks, fn t -> t.original_task_id == db_task.id end)
  end

  test "visibility timeout makes stuck tasks available again" do
    :ok = Ottr.insert(@queue, %{data: %{"type" => "generic", "args" => ["timeout_task"]}})
    task = Ottr.fetch_task(@queue)

    # Simulate a stuck task by setting locked_at in the past
    old_time = DateTime.add(DateTime.utc_now(), -400, :second)

    Ottr.OttrRepo.Tasks.update_task(Ottr.OttrRepo.Tasks.get_task!(task.id), %{
      locked_at: old_time,
      status: "in_progress"
    })

    # Re-initialize the queue to reload available tasks
    GenServer.stop({:via, Registry, {TaskQueueRegistry, @queue}})

    wait_until_stopped = fn fun ->
      case GenServer.whereis({:via, Registry, {TaskQueueRegistry, @queue}}) do
        nil -> :ok
        _ -> Process.sleep(50); fun.(fun)
      end
    end

    wait_until_stopped.(wait_until_stopped)
    {:ok, _pid} = Ottr.start_link(@queue)

    # Now the task should be available again
    retried_task = Ottr.fetch_task(@queue)
    assert retried_task.id == task.id
  end

  test "get all tasks returns buffer" do
    :ok = Ottr.insert(@queue, %{data: %{"type" => "generic", "args" => ["buffered1"]}})
    :ok = Ottr.insert(@queue, %{data: %{"type" => "generic", "args" => ["buffered2"]}})
    tasks = Ottr.get_all_tasks(@queue)
    assert Enum.any?(tasks, fn t -> t.data == "buffered1" end)
    assert Enum.any?(tasks, fn t -> t.data == "buffered2" end)
  end

  test "create multiple queues and insert tasks" do
    {:ok, _pid} = Ottr.create_queue("queue2")
    :ok = Ottr.insert("queue2", %{data: %{"type" => "generic", "args" => ["q2task"]}})
    task = Ottr.fetch_task("queue2")
    assert task.data == "q2task"
  end

  test "handle unknown queue gracefully" do
    assert catch_exit(Ottr.fetch_task("unknown_queue"))
  end
end
