defmodule Ottr.Repo.Migrations.AlterConditionInWorkflowSteps do
  use Ecto.Migration

  def change do
    alter table(:workflow_steps) do
      modify :condition, :jsonb, null: true
    end
  end
end
