# task/

This folder contains the Ecto schema for the `tasks` table.

## Files

- **task_val.ex**: Defines the `OttrRepo.TaskVal` schema and changeset for task records.
- **.formatter.exs**: Local formatter configuration for this folder.

## Purpose

Defines the structure and validation for task records in the database, including fields like `queue`, `data`, `status`, `retries`, and `locked_at`.

## Usage

Use the functions in `OttrRepo.Tasks` (see [`lib/tasks.ex`](../tasks.ex)) to create, update, and query