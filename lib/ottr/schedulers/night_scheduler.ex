#! Fallback for cron schedule - Don't use for now
defmodule Ottr.Schedulers.NightScheduler do
  use GenServer

  # client apis
  def start_link(_), do: GenServer.start_link(__MODULE__, nil, name: __MODULE__)

  @impl true
  def init(_) do
    schedule_nightly()
    {:ok, nil}
  end

  # server callbacks
  @impl true
  def handle_info(:nightly_task, state) do
    Ottr.insert("night_queue", "nightly_task")
    schedule_nightly()
    {:noreply, state}
  end

  # private function
  defp schedule_nightly do
    now = DateTime.utc_now()
    tomorrow = now |> DateTime.add(86400, :second) |> DateTime.truncate(:day)
    ms_until_midnight = DateTime.diff(tomorrow, now, :millisecond)
    Process.send_after(self(), :schedule_night, ms_until_midnight)
  end
end
