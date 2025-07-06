defmodule OttrRepo.WorkflowSteps do
  import Ecto.Query, warn: false
  alias OttrRepo
  alias OttrRepo.Workflows.WorkflowStep


  def get_step!(id), do: OttrRepo.get!(WorkflowStep, id)

  def list_steps_for_workflow(workflow_id) do
    WorkflowStep
    |> where([s], s.workflow_id == ^workflow_id)
    |> order_by([s], asc: s.position)
    |> OttrRepo.all()
  end

  def create_step(attrs \\ %{}) do
    %WorkflowStep{}
    |> WorkflowStep.changeset(attrs)
    |> OttrRepo.insert()
  end

  def update_step(%WorkflowStep{} = step, attrs) do
    step
    |> WorkflowStep.changeset(attrs)
    |> OttrRepo.update()
  end

  def delete_step(%WorkflowStep{} = step) do
    OttrRepo.delete(step)
  end

  # Change a step (for form changesets or validations)
  def change_step(%WorkflowStep{} = step, attrs \\ %{}) do
    WorkflowStep.changeset(step, attrs)
  end
end
