defmodule Ottr.Handlers.LogSender do
  @behaviour Ottr.Behaviours.Handlers
  require Logger

  @impl true
  def handle(%{"message" => message}) do
    Logger.info("[Workflow Log] #{message}")
    :ok
  end

  def handle(_), do: {:error, :missing_message}
end
