# test/

This folder contains the test suite for the Ottr project.

- **ottr_test.exs**: Main test file covering core features and behaviors of the Ottr queue system.
- Additional test files can be added here to cover more modules or edge cases.

## Usage

- Run all tests with:
  ```shell
  mix test
  ```
- Tests use ExUnit and the Ecto SQL Sandbox for database isolation and reliability.

## Notes

- Ensure your test database is configured in `config/test.exs`.
- Tests are designed to be comprehensive, covering queue creation, task insertion, retries, acknowledgments,