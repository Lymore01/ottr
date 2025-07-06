defmodule Ottr.Email do
  require Logger
  def send(%{"body" => _body, "subject" => subject, "to" => to}) do
    Logger.info("[Workflow] Sending email to #{to} with subject '#{subject}'")
    :ok
  end
end
