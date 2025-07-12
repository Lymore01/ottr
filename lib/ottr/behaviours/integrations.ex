defmodule Ottr.Behaviours.AppIntegrations do
  @moduledoc """
  Defines a standard behavior for all app integrations (Slack, Email, etc.)
  """

  @callback send(map()) :: :ok | {:error, term()}
end
