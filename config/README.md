# config/

This folder contains configuration files for the Ottr project.

- **config.exs**: Main configuration file. Sets up application-wide settings, including database connection details for development and production.
- **test.exs**: Test environment configuration. Overrides settings for running tests, such as using a separate test database and enabling the SQL sandbox for isolated test cases.

## Usage

- Adjust `config.exs` for your local or production database credentials and other application settings.
- `test.exs` is used automatically when running `mix test`.

## Setting Environment Variables

Ottr uses environment variables for database configuration.  
You can set these variables in your shell before running the application or tests.

**On Linux/macOS:**
```sh
export PGUSER=your_username
export PGPASSWORD=your_password
export PGHOST=localhost
export PGDATABASE=ottr
export PGPORT=5432
```

**On Windows CMD:**
```cmd
set PGUSER=your_username
set PGPASSWORD=your_password
set PGHOST=localhost
set PGDATABASE=ottr
set PGPORT=5432
```

**On Windows PowerShell:**
```powershell
$env:PGUSER="your_username"
$env:PGPASSWORD="your_password"
$env:PGHOST="localhost"
$env:PGDATABASE="ottr"
$env:PGPORT="5432"
```

If you do not set these variables, default values from the config files will be used.

For more advanced configuration, see the [Elixir Config documentation](https://hexdocs.pm/elixir/Config.html)