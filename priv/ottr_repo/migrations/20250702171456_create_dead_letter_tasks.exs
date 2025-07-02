defmodule OttrRepo.Migrations.CreateDeadLetterTasks do
  use Ecto.Migration

  def change do
create table(:dead_letter_tasks) do
  add :original_task_id, :integer
  add :queue, :string
  add :data, :map
  add :retries, :integer
  add :reason, :string
  timestamps()
end
  end
end
