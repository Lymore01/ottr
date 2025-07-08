defmodule Ottr.Behaviours.Handlers do
  @callback handle(map()) :: :ok | {:error, term()}
end
