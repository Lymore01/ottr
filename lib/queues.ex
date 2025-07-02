defmodule OttrRepo.Queues do
  import Ecto.Query, warn: false
  alias OttrRepo
  alias OttrRepo.Queue

  def list_queues do
    OttrRepo.all(Queue)
  end

  def create_queue(name, description \\ nil) do
    attrs = %{name: name, description: description}

    %Queue{}
    |> Queue.changeset(attrs)
    |> OttrRepo.insert()
  end

  def get_queue_by_name(name) do
    OttrRepo.get_by(Queue, name: name)
  end

  def delete_queue(%Queue{} = queue) do
    OttrRepo.delete(queue)
  end
end
