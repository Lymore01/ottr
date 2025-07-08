defmodule Ottr.OttrRepo.Workflows.Step do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ottr.OttrRepo.Workflow

  schema "workflow_steps" do
    field :position, :integer
    field :type, :string
    field :args, :map
    field :condition, Ottr.Types.OttrRepo.Condition

    belongs_to :workflow, Workflow

    timestamps()
  end

  def changeset(step, attrs) do
    step
    |> cast(attrs, [:position, :type, :args, :condition, :workflow_id])
    |> validate_required([:position, :type, :args, :workflow_id])
  end
end
