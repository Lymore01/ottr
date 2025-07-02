# Ottr: Distributed Task Queue for Elixir

Ottr is a robust, concurrent, and persistent task queue built with Elixir. It leverages GenServer processes, Ecto for persistence, and supports multiple named queues, task retries, visibility timeouts, and more. Ottr is designed for reliability, scalability, and ease of integration into your Elixir projects.

---

## Features

- **Multiple Named Queues:** Dynamically create and manage multiple queues.
- **Task Buffering & Flushing:** Tasks are buffered and flushed in batches for efficiency.
- **Concurrency Control:** Tasks are processed concurrently using a worker pool.
- **Persistence:** All tasks are stored in a database using Ecto.
- **Retry Mechanism:** Failed tasks are retried up to a configurable limit.
- **Visibility Timeout:** Stuck tasks become available again after a timeout.
- **Task Acknowledgment:** Explicitly acknowledge completed tasks.
- **Graceful Shutdown:** Ensures all buffered tasks are flushed before shutdown.
- **Extensive Test Coverage:** Includes ExUnit tests for all core features.

---

## Architecture

Ottr is built on proven OTP patterns for reliability and scalability:

- **Supervision Tree:** All queue processes, workers, and registries are supervised for automatic recovery and fault tolerance.
- **Registries:** Elixir’s Registry is used to dynamically register and look up queue processes by name.
- **Poolboy:** A Poolboy worker pool manages concurrent task processing, ensuring efficient use of system resources.

This architecture ensures that Ottr can handle high loads, recover from failures, and scale with your application.

---

## Installation

Add `ottr` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ottr, "~> 0.1.0"}
  ]
end
```

Then run:

```shell
mix deps.get
```

---

## Usage

### Creating a Queue

```elixir
Ottr.create_queue("my_queue")
```

### Inserting a Task

```elixir
:ok = Ottr.insert("my_queue", "some payload")
```

### Fetching and Acknowledging a Task

```elixir
task = Ottr.fetch_task("my_queue")
# ...process task...
{:ok, _} = Ottr.ack_task("my_queue", task.id)
```

### Getting All Tasks in a Queue

```elixir
tasks = Ottr.get_all_tasks("my_queue")
```

---

## Configuration

You can configure buffer size, flush interval, retry limits, and timeout in your application config:

```elixir
config :ottr,
  flush_interval_ms: 60_000,
  max_buffer_size: 5,
  retry_limit: 3,
  timeout_seconds: 300
```

---

## Testing

Run the test suite with:

```shell
mix test
```

## Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

---

## License

[MIT](LICENSE)

---

## Credits

Created by Kelly Limo. Inspired by distributed queue systems and the power of Elixir/OTP.