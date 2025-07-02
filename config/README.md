# config/

This folder contains configuration files for the Ottr project.

- **config.exs**: Main configuration file. Sets up application-wide settings, including database connection details for development and production.
- **test.exs**: Test environment configuration. Overrides settings for running tests, such as using a separate test database and enabling the SQL sandbox for isolated test cases.

## Usage

- Adjust `config.exs` for your local or production database credentials and other application settings.
- `test.exs` is used automatically when running `mix test`.

For more advanced configuration, see the