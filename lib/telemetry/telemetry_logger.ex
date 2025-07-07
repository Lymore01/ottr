defmodule Ottr.Telemetry.TelemetryLogger do
  @behaviour Ottr.Telemetry
  require Logger

  def handle_event([:ottr, :task, :started], _measurements, metadata, _config) do
    Logger.info("[Telemetry] Task started: #{inspect(metadata)}")
  end

  def handle_event([:ottr, :task, :completed], %{duration: duration}, metadata, _config) do
    Logger.info("[Telemetry] Task completed in #{duration}ns: #{inspect(metadata)}")
  end

  def handle_event([:ottr, :task, :failed], %{duration: duration}, metadata, _config) do
    Logger.error("[Telemetry] Task failed in #{duration}ns: #{inspect(metadata)}")
  end

  def handle_event([:ottr, :task, :retry], %{retry: retry}, metadata, _config) do
    Logger.warning("[Telemetry] Task retry ##{retry}: #{inspect(metadata)}")
  end

  def handle_event([:ottr, :task, :dead_letter], _m, metadata, _config) do
    Logger.error("[Telemetry] Task moved to dead letter queue: #{inspect(metadata)}")
  end

  def handle_event([:ottr, :queue, :flush], %{count: count}, %{queue: queue}, _config) do
    Logger.info("[Telemetry] Flushed #{count} tasks from queue: #{queue}")
  end

  # workflow
  def handle_event([:ottr, :workflow, :completed], %{duration: duration}, metadata, _config) do
    Logger.info("[Telemetry] Workflow completed in #{duration} ms: #{inspect(metadata)}")
  end

  def handle_event(event, measurements, metadata, _config) do
    Logger.warning(
      "Unhandled event: #{inspect(event)} #{inspect(measurements)} #{inspect(metadata)}"
    )
  end
end
