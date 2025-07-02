import Config

config :ottr,
  ecto_repos: [OttrRepo]

config :ottr, OttrRepo,
   username: System.get_env("PGUSER") || "postgres",
  password: System.get_env("PGPASSWORD") || "postgres",
  hostname: System.get_env("PGHOST") || "localhost",
  database: System.get_env("PGDATABASE") || "ottr",
  port: String.to_integer(System.get_env("PGPORT") || "5432"),
  pool_size: 10,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true
