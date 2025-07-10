# Ottr - Task Queue / Workflow System

**Ottr** is an Elixir-based task queue system for managing workflows, tasks, and condition-based actions. This guide walks you through the process of seeding a workflow with steps and inserting it into the task queue.

---

## Features

- **Task Queues**: Easily create and manage queues
- **Workflows**: Create workflows that consist of steps, with optional conditions
- **Dynamic Task Execution**: Tasks can be executed sequentially based on conditions
- **Conditional Steps**: Workflows can include conditional logic, ensuring tasks run only under certain circumstances
- **Template Resolution**: Resolve template variables within strings based on a provided context.

---

## Requirements

- **Elixir** 1.12 or later
- **Erlang** 24 or later
- **PostgreSQL** for managing workflow, task, and queue data

---

## Example: Seeding a Workflow

This section demonstrates how to seed a workflow with conditional steps and enqueue the task to start the workflow.

### 1. Create the Queue

First, create a new queue where the tasks will be processed:

```elixir
Ottr.create_queue("default")
```

### 2. Create the Workflow

Next, create a workflow with the following properties:

- **name**: The name of the workflow
- **queue**: The queue where the workflow will run
- **trigger_type**: The type of trigger (in this case, manual)
- **trigger_data**: Additional data for the trigger

```elixir
{:ok, workflow} =
  Workflows.create_workflow(%{
    name: "User Welcome Workflow",
    queue: "default",
    trigger_type: "manual",
    trigger_data: %{"note" => "Triggered manually from seeds"}
  })
```

### 3. Add Steps to the Workflow

You can add multiple steps to the workflow, with optional conditions evaluated by custom parser `condition_parser.ex` that determine when each step runs.

#### Step 1: Log Step (Always Runs)

This step logs the message "Starting workflow for {{user_name}}". It runs unconditionally.

```elixir
Workflows.create_step(%{
  position: 1,
  type: "log_sender",
  args: %{"message" => "Starting workflow for {{user_name}}"},
  condition: nil,
  workflow_id: workflow.id
})
```

#### Step 2: Send Email (Runs if User is Verified)

This step sends a welcome email to the user if the `user.verified` condition is true.

```elixir
Workflows.create_step(%{
  position: 2,
  type: "email_sender",
  args: %{
    "to" => "{{user_email}}",
    "subject" => "Welcome, {{user_name}}!",
    "body" => "Hi {{user_name}},\n\nWe're glad to have you onboard."
  },
  condition: "user.verified == true",
  workflow_id: workflow.id
})
```

#### Step 3: Log Success (Only if User is Admin or Verified)

This step logs the message "Email sent to {{user_email}}" if the condition `user.verified == true or user.admin == true` is met.

```elixir
Workflows.create_step(%{
  position: 3,
  type: "log_sender",
  args: %{"message" => "Email sent to {{user_email}}"},
  condition: "user.verified == true or user.admin == true",
  workflow_id: workflow.id
})
```

### 4. Enqueue the Task to Start the Workflow

Finally, enqueue a task to start the workflow by passing in the workflow ID, the starting step, and context data (including user details).

```elixir
Ottr.insert("default", %{
  data: %{
    "type" => "workflow_runner",
    "args" => %{
      "workflow_id" => workflow.id,
      "step" => 1,
      "context" => %{
        "user_name" => "Jane Doe",
        "user_email" => "jane@example.com",
        "user" => %{
          "verified" => true,
          "admin" => false
        }
      }
    }
  }
})

IO.puts("🚀 Seeded workflow with conditional steps and queued initial task.")
```

## Example Workflow Breakdown

**Workflow**: "User Welcome Workflow"

1. **Step 1**: Logs "Starting workflow for {{user_name}}" (always runs)
2. **Step 2**: Sends a welcome email if `user.verified == true`
3. **Step 3**: Logs "Email sent to {{user_email}}" if the user is verified or an admin

---

## Usage

To use Ottr in your application:

1. Create queues for different types of tasks
2. Define workflows with conditional steps
3. Enqueue tasks to trigger workflow execution
4. Monitor task processing and workflow completion


---
```shell
mix run --no-halt priv/repo/seeds.exs
``` 

The system automatically handles task execution based on the defined conditions and workflow structure.

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