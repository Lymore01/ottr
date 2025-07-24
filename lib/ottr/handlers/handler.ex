defmodule Ottr.Handlers.Handler do
  @moduledoc """
  Dynamically resolves task handlers based on task `type`.
  """
  @spec resolve_handler(String.t()) :: module()
  def resolve_handler(type) when is_binary(type) do
    handler = Application.get_env(:ottr, :email_sender_handler)

    handler =
      if handler do
        handler
      else
        type
        |> Macro.camelize()
        |> then(&Module.concat([Ottr.Handlers, &1]))
      end

    IO.inspect(handler, label: "Resolved Handler")

    if Code.ensure_loaded?(handler) and function_exported?(handler, :handle, 1) do
      handler
    else
      raise ArgumentError,
            "No valid handler found for task type #{inspect(type)} (looked for #{inspect(handler)})"
    end
  end
end
