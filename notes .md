# TODO
# 1. Add task to Queue - DONE
# 2. Retry mechanism - DONE
# 3. Multiple queues and topics - DONE
# 4. Task acknowledgment - DONE
# 5. Concurrency control - DONE
# 6. Persistence / Durability - DONE
# 7. Dead letter queue - DONE
# 8. Visibility timeout - DONE
# 9. Monitoring and metrics
# 10. Robust error handling - PARTIAL
# 11. Graceful shutdown
# 12. Documentation and examples
# 13. Testing and validation - DONE
# 14. Security considerations
# 15. Workflow duration - DONE
# 16. Out off the box app integrations ie. Slack, whatsapp, YT, tiktok
# 17. Webhook listeners
# 18. Data mapping, data from one step can be consumed by another
# 19. Add conditionals in context, to choose the next step based on the condition - DONE
# 20. Create a parser - PARTIAL, more capabilities below
<!-- more parser features -->
parentheses - DONE
negation
inclusion checks "in"
custom funcs eg start_with
arithmetic
typecasting 
error reporting



:telemetry.execute(event_name, measurements, metadata)

Ottr.TelemetryLogger.handle_event(
  [:ottr, :queue, :flush],
  %{count: 5},                 # measurements
  %{queue: "default"},         # metadata
  nil                          # config
)

add telemetry to important points in the system

Emit events for:

Task started

Task completed

Task failed

Retry attempts

Dead letter insertion

Queue flush

| Event                              | Metrics                       |
| ---------------------------------- | ----------------------------- |
| `[:ottr, :task, :started]`         | Task type, queue name         |
| `[:ottr, :task, :completed]`       | Duration, queue, task type    |
| `[:ottr, :task, :failed]`          | Reason, retry count, duration |
| `[:ottr, :queue, :length]`         | Buffer size over time         |
| `[:ottr, :dead_letter, :inserted]` | When a task hits retry limit  |



/ottr
├── config/                 # Configuration files (env configs, releases)
│   ├── config.exs
│   ├── dev.exs
│   ├── prod.exs
│   └── test.exs
│
├── lib/                    # Main source code
│   ├── ottr/               # Core Ottr app modules
│   │   ├── application.ex  # OTP Application start
│   │   ├── repo.ex         # Ecto repo module
│   │   ├── queue.ex        # Queue logic (creation, management)
│   │   ├── worker.ex       # Worker GenServer to process jobs
│   │   ├── job.ex          # Job struct & validation
│   │   ├── scheduler.ex    # Cron/scheduling functionality
│   │   ├── retry.ex        # Retry logic & backoff strategies
│   │   ├── middleware/     # Middleware pipeline for hooks/hooks
│   │   │   └── ...
│   │   ├── telemetry/      # Telemetry events & metrics setup
│   │   │   └── ...
│   │   ├── storage/        # Persistence layer abstraction (Ecto, ETS, etc.)
│   │   │   └── ...
│   │   └── cluster/        # Cluster/distribution helpers
│   │       └── ...
│   │
│   ├── ottr_web/           # Web dashboard (Phoenix app or LiveView)
│   │   ├── endpoint.ex
│   │   ├── router.ex
│   │   ├── controllers/
│   │   ├── templates/
│   │   ├── live/           # LiveView components
│   │   ├── channels/       # WebSocket channels
│   │   └── assets/         # JS, CSS, images for dashboard
│   │
│   └── ottr_cli/           # Optional CLI tool to interact with Ottr
│       ├── cli.ex
│       └── commands/
│           └── enqueue.ex  # Command to enqueue jobs from CLI
│
├── priv/                   # Database migrations, seeds, static assets
│   ├── repo/
│   │   └── migrations/
│   └── static/
│
├── test/                   # Tests grouped by module
│   ├── ottr/
│   ├── ottr_web/
│   └── support/
│
├── docs/                   # Documentation, guides, design docs
│
├── scripts/                # Build, deploy, or utility scripts
│
├── .formatter.exs          # Code formatter config
├── mix.exs                 # Mix project config
├── README.md               # Project overview & quick start
└── LICENSE


Exactly-once task locking > Robust retry + dead letter queue > Crash recovery > Observability

Ottr.insert("signup_queue", %{
  data: %{
    "type" => "workflow_runner",
    "args" => %{
      "workflow_id" => 1,
      "step" => 1,
      "context" => %{
        "email" => "jane@example.com",
        "user_id" => "abc123"
      }
    }
  }
})

<!-- conditionals -->
Workflows.create_step(%{
  "position": 2,
  "type": "send_email",
  "args": { "to": "{{user_email}}", "subject": "Hi!" },
  "condition": { "user_subscribed": true } # run only when user is subscribed
  "workflow_id": workflow.id
})

Ottr.insert("default", %{
  data: %{
    "type" => "send_email",
   "args" => %{
    "body" => "Thank you for signing up.",
    "subject" => "Welcome to Ottr!",
    "to" => "user@example.com"
  }
  }
})


Webhook triggers

Step result passing

Optional: conditionals, delays, visual flow




<!-- parser -->
expr = "user.age >= 18 and user.verified == true"
context = %{
  "user" => %{
    "age" => 25,
    "verified" => true
  }
}

Ottr.Utils.ConditionParser.eval(expr, context)
# => true
