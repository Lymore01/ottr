defmodule OttrRepo.Migrations.AddConditionToWorkflowSteps do
  use Ecto.Migration

  def change do
    alter table(:workflow_steps) do
      add :condition, :map
    end
  end
end
