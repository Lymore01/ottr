defmodule Ottr.OttrRepo.QueueTask do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :queue, :string
    field :data, :map
    field :status, :string, default: "pending"
    field :retries, :integer, default: 0
    field :locked_at, :utc_datetime_usec
    timestamps()
  end

  def changeset(task, attrs) do
    task
    |> cast(attrs, [:queue, :data, :status, :retries, :locked_at])
    |> validate_required([:queue, :data])
  end
end
