defmodule OttrRepo.Migrations.AddWorkflowTimestamps do
  use Ecto.Migration

  def change do
  alter table(:workflows) do
    add :started_at, :utc_datetime_usec
    add :finished_at, :utc_datetime_usec
  end
end
end
