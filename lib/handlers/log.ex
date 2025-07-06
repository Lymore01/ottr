defmodule Ottr.TaskHandlers.Log do
  @behaviour Ottr.TaskHandler
  require Logger

  @impl true
  def handle(%{"message" => message}) do
    Logger.info("[Workflow Log] #{message}")
    :ok
  end

  def handle(_), do: {:error, :missing_message}
end
