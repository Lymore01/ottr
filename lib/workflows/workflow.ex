defmodule OttrRepo.Workflows.Workflow do
  use Ecto.Schema
  import Ecto.Changeset

  alias OttrRepo.Workflows.WorkflowStep

  schema "workflows" do
    field :name, :string
    field :queue, :string
    field :trigger_type, :string
    field :trigger_data, :map
    field :started_at, :utc_datetime_usec
    field :finished_at, :utc_datetime_usec

    has_many :workflow_steps, WorkflowStep, on_replace: :delete

    timestamps()
  end

  def changeset(workflow, attrs) do
    workflow
    |> cast(attrs, [:name, :queue, :trigger_type, :trigger_data, :started_at, :finished_at])
    |> validate_required([:name, :trigger_type])
    |> cast_assoc(:workflow_steps)
  end
end
