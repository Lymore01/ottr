defmodule OttrRepo.DeadLetterTasks do
  import Ecto.Query, warn: false
  alias OttrRepo
  alias OttrRepo.DeadLetter

  def list_dead_letters do
    OttrRepo.all(DeadLetter)
  end

  def move_to_dead_letter(task, reason) do
    attrs = %{
      original_task_id: task.id,
      queue: task.queue,
      data: task.data,
      retries: task.retries,
      reason: reason
    }

    %DeadLetter{}
    |> DeadLetter.changeset(attrs)
    |> OttrRepo.insert()
  end
end
