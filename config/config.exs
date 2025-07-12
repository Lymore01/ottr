# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :ottr,
  ecto_repos: [Ottr.Repo],
  generators: [timestamp_type: :utc_datetime]

# Minute Hour Day Month Day_of_fWeek
config :ottr, Ottr.Scheduler,
  timezone: "Africa/Nairobi",
  jobs: [
    {"59 17 * * *",
     fn ->
       require Logger
       Ottr.create_queue("evening_queue")
       Logger.info("Quantum task scheduled and enqueued!")
       Ottr.insert("evening_queue", "nightly_task")
     end}
  ]

# Configures the endpoint
config :ottr, OttrWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: OttrWeb.ErrorHTML, json: OttrWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Ottr.PubSub,
  live_view: [signing_salt: "x7hr+4KA"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :ottr, Ottr.Mailer, adapter: Swoosh.Adapters.Local

# TODO: uncomment this in prod
# config :sample, Sample.Mailer,
#   adapter: Swoosh.Adapters.Sendgrid,
#   api_key: Application.get_env(:ottr, :sendgrid_api_key)

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  ottr: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  ottr: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
