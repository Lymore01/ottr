# queue/

This folder contains the Ecto schema for the `queues` table.

## Files

- **queue.ex**: Defines the `OttrRepo.Queue` schema and changeset for queue records.
- **.formatter.exs**: Local formatter configuration for this folder.

## Purpose

Defines the structure and validation for queue records in the database, including fields like `name` and `description`.

## Usage

Use the functions in `OttrRepo.Queues` (see [`lib/queues.ex`](../queues.ex)) to create, list, and manage queues.