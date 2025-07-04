defmodule Ottr.TaskHandlers.SendEmail do
  @behaviour Ottr.TaskHandler

  def handle(args), do: Ottr.Email.send(args)
end
