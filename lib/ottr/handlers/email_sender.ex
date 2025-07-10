defmodule Ottr.Handlers.EmailSender do
  @behaviour Ottr.Behaviours.Handlers

  def handle(args) do
    case args do
      %{"body" => _body, "subject" => _subject, "to" => _to} ->
        Ottr.Integrations.Email.send(args)

      _invalid_args ->
        raise ArgumentError, "Invalid arguments passed to EmailSender: #{inspect(args)}"
    end
  end
end
