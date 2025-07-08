defmodule Ottr.Handlers.EmailSender do
  @behaviour Ottr.Behaviours.Handlers

  def handle(args), do: Ottr.Integrations.Email.send(args)
end
