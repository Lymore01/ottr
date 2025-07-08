defmodule Ottr.Repo.Migrations.CreateQueues do
  use Ecto.Migration

  def change do
    create table(:queues) do
      add :name, :string, null: false
      add :description, :string
      timestamps()
    end

    create unique_index(:queues, [:name])
  end
end
