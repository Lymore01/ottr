defmodule Ottr.Integrations.Email do
  @behaviour Ottr.Behaviours.AppIntegrations
  require Logger
  import Swoosh.Email

  @impl true
  def send(%{"to" => to, "subject" => _subject, "body" => _body} = data) do
    email = email_body(data)
    Ottr.Mailer.deliver(email)
    Logger.info("Email imetumwa to: #{to}")
    :ok
  end

  def send(_), do: {:error, :invalid_payload}

  defp email_body(%{"to" => to, "subject" => subject, "body" => body}) do
    new()
    |> to({"Ottr User", to})
    |> from({"Ottr", "ottr@exmaple.com"})
    |> subject(subject)
    |> html_body("<h1>#{body}</h1>")
    |> text_body("Hello Ottr User\n")
  end
end
