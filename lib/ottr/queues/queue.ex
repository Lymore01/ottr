defmodule Ottr.OttrRepo.Queue do
  use Ecto.Schema
  import Ecto.Changeset

  schema "queues" do
    field :name, :string
    field :description, :string
    timestamps()
  end

  def changeset(queue, attrs) do
    queue
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
