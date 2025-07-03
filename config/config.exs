import Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :ottr,
  ecto_repos: [OttrRepo]

# Minute Hour Day Month Day_o_fWeek
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

config :ottr, OttrRepo,
  username: System.get_env("PGUSER") || "postgres",
  password: System.get_env("PGPASSWORD") || "postgre",
  hostname: System.get_env("PGHOST") || "localhost",
  database: System.get_env("PGDATABASE") || "ottr",
  port: String.to_integer(System.get_env("PGPORT") || "5432"),
  pool_size: 10,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true
