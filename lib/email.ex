defmodule Ottr.Email do
  def send(%{"body" => _body, "subject" => subject, "to" => to}) do
    IO.puts("Sending email to #{to} with subject '#{subject}'")
    :ok
  end
end
