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
