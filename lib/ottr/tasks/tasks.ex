defmodule Ottr.OttrRepo.Tasks do
  import Ecto.Query, warn: false
  alias Ottr.Repo, as: OttrRepo
  alias Ottr.OttrRepo.QueueTask, as: Task

  def list_tasks do
    OttrRepo.all(Task)
  end

  def list_tasks_for_queue(queue_name) do
    from(t in Task, where: t.queue == ^queue_name and t.status in ["pending", "in_progress"])
    |> OttrRepo.all()
  end

  def list_available_tasks_for_queue(queue_name, timeout_seconds \\ 300) do
    threshold = DateTime.add(DateTime.utc_now(), -timeout_seconds, :second)

    from(t in Task,
      where:
        t.queue == ^queue_name and
          (t.status == "pending" or
             (t.status == "in_progress" and not is_nil(t.locked_at) and t.locked_at < ^threshold))
    )
    |> OttrRepo.all()
  end

  def get_task(id) do
    Task
    |> OttrRepo.get(id)
  end

  # throw error if no task is found
  def get_task!(id) do
    Task
    |> OttrRepo.get!(id)
  end

  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> OttrRepo.insert()
  end

  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> OttrRepo.update()
  end

  def delete_task(%Task{} = task) do
    OttrRepo.delete(task)
  end
end
