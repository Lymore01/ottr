alias Ottr.OttrRepo.Workflows
alias Ottr.Repo, as: OttrRepo

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

# 3. Add steps to the workflow (with optional conditions)

# Step 1: Log - always runs
Workflows.create_step(%{
  position: 1,
  type: "log_sender",
  args: %{"message" => "Starting workflow for {{user_name}}"},
  condition: nil,
  workflow_id: workflow.id
})

# Step 2: Send email - only if user is verified
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

# Step 3: Log success - only if user is admin OR verified
Workflows.create_step(%{
  position: 3,
  type: "log_sender",
  args: %{"message" => "Email sent to {{user_email}}"},
  condition: "user.verified == true or user.admin == true",
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
