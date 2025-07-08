defmodule Ottr.Repo.Migrations.CreateWorkflowSteps do
  use Ecto.Migration

  def change do
    create table(:workflow_steps) do
      add :workflow_id, references(:workflows, on_delete: :delete_all), null: false
      add :position, :integer, null: false
      add :type, :string, null: false
      add :args, :map, null: false

      timestamps()
    end

    create index(:workflow_steps, [:workflow_id])
    create unique_index(:workflow_steps, [:workflow_id, :position])
  end
end
