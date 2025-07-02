defmodule OttrRepo.Migrations.CreateTasksTable do
  use Ecto.Migration

 def change do
  create table(:tasks) do
    add :queue, :string
    add :data, :map
    add :status, :string, default: "pending"
    add :retries, :integer, default: 0
    add :locked_at, :utc_datetime_usec
    timestamps()
  end

  create index(:tasks, [:queue])
  create index(:tasks, [:status])
end
end
