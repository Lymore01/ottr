defmodule OttrApp do
  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: TaskQueueRegistry},
      {DynamicSupervisor, strategy: :one_for_one, name: TaskQueueSupervisor},
      :poolboy.child_spec(
        :task_worker_pool,
        name: {:local, :task_worker_pool},
        worker_module: TaskWorker,
        size: 5,
        max_overflow: 2
      ),
      OttrRepo,
      Ottr.Scheduler
    ]

    :telemetry.attach_many(
      "ottr-logger",
      [
        [:ottr, :task, :started],
        [:ottr, :task, :completed],
        [:ottr, :task, :failed],
        [:ottr, :task, :retry],
        [:ottr, :task, :dead_letter],
        [:ottr, :queue, :flush],
        [:ottr, :workflow, :completed]
      ],
      &Ottr.Telemetry.TelemetryLogger.handle_event/4,
      nil
    )

    opts = [strategy: :one_for_one, name: Ottr.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
