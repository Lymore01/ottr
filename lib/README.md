# lib/

This folder contains the main application code for the Ottr distributed task queue.

## Structure

- **ottr.ex**: Application entry point. Sets up the supervision tree, including registries, dynamic supervisors, Poolboy worker pool, and the Ecto repo.
- **ottr_queue.ex**: Core GenServer implementation for queue processes. Handles task buffering, flushing, retries, acknowledgments, and concurrency.
- **ottr_repo.ex**: Ecto repository configuration for database interactions.
- **queues.ex**: Ecto context for managing queue records in the database.
- **tasks.ex**: Ecto context for managing task records, including creation, updates, and queries.
- **task_worker.ex**: Worker module used by Poolboy for concurrent task processing.
- **queue/**: Contains Ecto schema for queues. See [queue/README.md](queue/README.md).
- **task/**: Contains Ecto schema for tasks. See [task/README.md](task/README.md).

## Notes

- The supervision tree leverages Elixir's OTP features for reliability and fault tolerance.
- Poolboy is used for efficient concurrent task processing.
- Registries enable dynamic queue process lookup by name.
- All database persistence is handled through Ecto schemas and contexts.

Refer to individual module documentation for more details on each component.