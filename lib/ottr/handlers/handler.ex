defmodule Ottr.Handlers.Handler do
  @moduledoc """
  Dynamically resolves task handlers based on task `type`.
  """
  @spec resolve_handler(String.t()) :: module()
  def resolve_handler(type) when is_binary(type) do
    mod =
      type
      |> Macro.camelize()
      |> then(&Module.concat([Ottr.Handlers, &1]))

    if Code.ensure_loaded?(mod) and function_exported?(mod, :handle, 1) do
      mod
    else
      raise ArgumentError,
            "No valid handler found for task type #{inspect(type)} (looked for #{inspect(mod)})"
    end
  end
end
