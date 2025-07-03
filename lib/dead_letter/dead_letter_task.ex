defmodule OttrRepo.DeadLetter do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dead_letter_tasks" do
    field :original_task_id, :integer
    field :queue, :string
    field :data, :map
    field :retries, :integer
    field :reason, :string
    timestamps()
  end

  def changeset(dead_letter, attrs) do
    dead_letter
    |> cast(attrs, [:original_task_id, :queue, :data, :retries, :reason])
    |> validate_required([:original_task_id, :queue, :data, :retries, :reason])
  end
end
