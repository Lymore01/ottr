defmodule Ottr.Repo do
  use Ecto.Repo,
    otp_app: :ottr,
    adapter: Ecto.Adapters.Postgres
end
