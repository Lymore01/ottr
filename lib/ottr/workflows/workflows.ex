defmodule Ottr.OttrRepo.Workflows do
  import Ecto.Query, warn: false
  alias Ottr.Repo, as: OttrRepo
  alias Ottr.OttrRepo.Workflow
  alias Ottr.OttrRepo.Workflows.Step, as: WorkflowStep

  def list_workflows do
    OttrRepo.all(Workflow)
  end

  @spec get_workflow!(any()) ::
          nil | [%{optional(atom()) => any()}] | %{optional(atom()) => any()}
  def get_workflow!(id) do
    OttrRepo.get!(Workflow, id) |> OttrRepo.preload(:workflow_steps)
  end

  def create_workflow(attrs \\ %{}) do
    %Workflow{}
    |> Workflow.changeset(attrs)
    |> OttrRepo.insert()
  end

  def create_workflow!(attrs \\ %{}) do
    %Workflow{}
    |> Workflow.changeset(attrs)
    |> OttrRepo.insert()
  end

  def update_workflow(%Workflow{} = workflow, attrs) do
    workflow
    |> Workflow.changeset(attrs)
    |> OttrRepo.update()
  end

  def list_steps(workflow_id) do
    WorkflowStep
    |> where([s], s.workflow_id == ^workflow_id)
    |> order_by([s], asc: s.position)
    |> OttrRepo.all()
  end

  def create_step(attrs) do
    %WorkflowStep{}
    |> WorkflowStep.changeset(attrs)
    |> OttrRepo.insert()
  end

  def update_step(step, attrs) do
    step
    |> WorkflowStep.changeset(attrs)
    |> OttrRepo.update()
  end

  def delete_step(step) do
    OttrRepo.delete(step)
  end

  def delete_workflow(%Workflow{} = workflow) do
    OttrRepo.delete(workflow)
  end
end
