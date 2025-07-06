defmodule Ottr.Telemetry do
  @callback handle_event([atom()], map(), map(), term()) :: any()
end
