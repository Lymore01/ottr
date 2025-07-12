defmodule Ottr.Integrations.Dispatcher do
  @moduledoc """
  Routes integration messages to the appropriate integration module.
  """

  alias Ottr.Integrations.{Email}

  @integration_modules %{
    # "slack" => SlackIntegration
    "email" => Email,
    # "whatsapp" => Ottr.Integrations.WhatsAppIntegration
  }

  def send_integration(%{"type" => type} = payload) do
    case Map.get(@integration_modules, type) do
      nil -> {:error, :unsupported_integration}
      module -> module.send(payload["args"] || %{})
    end
  end
end
