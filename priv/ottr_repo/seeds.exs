alias OttrRepo.Workflows
alias OttrRepo

# 1. Create the queue
Ottr.create_queue("default")

# 2. Create the workflow
{:ok, workflow} =
  Workflows.create_workflow(%{
    name: "User Welcome Workflow",
    queue: "default",
    trigger_type: "manual",
    trigger_data: %{"note" => "Triggered manually from seeds"}
  })

# 3. Add steps to the workflow
Workflows.create_step(%{
  position: 1,
  type: "log",
  args: %{"message" => "Starting workflow for {{user_name}}"},
  workflow_id: workflow.id
})

Workflows.create_step(%{
  position: 2,
  type: "send_email",
  args: %{
    "to" => "{{user_email}}",
    "subject" => "Welcome, {{user_name}}!",
    "body" => "Hi {{user_name}},\n\nWe're glad to have you onboard."
  },
  workflow_id: workflow.id
})

Workflows.create_step(%{
  position: 3,
  type: "log",
  args: %{"message" => "Email sent to {{user_email}}"},
  workflow_id: workflow.id
})

# 4. Enqueue the task to start the workflow
Ottr.insert("default", %{
  data: %{
    "type" => "workflow_runner",
    "args" => %{
      "workflow_id" => workflow.id,
      "step" => 1,
      "context" => %{
        "user_name" => "Jane Doe",
        "user_email" => "jane@example.com"
      }
    }
  }
})

IO.puts("🚀 Seeded workflow and queued initial task.")
