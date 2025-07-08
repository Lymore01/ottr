defmodule Ottr.Handlers.Generic do
  @behaviour Ottr.Behaviours.Handlers
  require Logger

  @impl true
  def handle(%{"args" => args, "type" => "generic"}) do
    try do
      Logger.info("[Generic Task] Processing with arguments: #{inspect(args)}")


      process_generic_task(args)

      :ok
    rescue
      e ->
        Logger.error("Task failed with error: #{inspect(e)}")
        {:error, :task_processing_failed}
    end
  end

  def handle(_), do: {:error, :invalid_task_format}

  defp process_generic_task(args) do

    Logger.info("Processing task with args: #{inspect(args)}")


    case Map.get(args, "key1") do
      nil -> Logger.warn("key1 not found in the arguments")
      value -> Logger.info("Processing value for key1: #{value}")
    end

  end
end
