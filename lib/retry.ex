defmodule Ottr.Retry do
  require Logger
  @base_delay 1_000

  def maybe_retry(task, queue_name, retry_limit, via_tuple, tasks_mod, dead_letter_mod) do
    fetch_task = tasks_mod.get_task!(task.id)
    retries = Map.get(fetch_task, :retries, 0) + 1

    if retries < retry_limit do
      tasks_mod.update_task(fetch_task, %{retries: retries, status: "pending", locked_at: nil})

      # exponential backoff formula
      delay = (@base_delay * :math.pow(2, retries - 1)) |> round()

      Process.send_after(
        self(),
        {:retry_task, queue_name, %{task | retries: retries}, via_tuple},
        delay
      )

      Logger.warning("Task failed, retrying: #{inspect(task.data)} (Attempt #{retries})")
      :retrying
    else
      tasks_mod.update_task(fetch_task, %{status: "failed", locked_at: nil})
      dead_letter_mod.move_to_dead_letter(fetch_task, "retry_limit_reached")
      Logger.error("Task failed after retries: #{inspect(task.data)}")
      :dead_lettered
    end
  end
end
