defmodule OttrRepo.Migrations.CreateWorkflows do
  use Ecto.Migration

  def change do
    create table(:workflows) do
      add :name, :string, null: false
      add :queue, :string
      add :trigger_type, :string, null: false
      add :trigger_data, :map

      timestamps()
    end
  end
end
