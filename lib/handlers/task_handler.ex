defmodule Ottr.TaskHandler do
  @callback handle(map()) :: :ok | {:error, term()}
end
