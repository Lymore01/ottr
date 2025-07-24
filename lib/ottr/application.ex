defmodule Ottr.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      OttrWeb.Telemetry,
      Ottr.Repo,
      {DNSCluster, query: Application.get_env(:ottr, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Ottr.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Ottr.Finch},
      # Start a worker by calling: Ottr.Worker.start_link(arg)
      # {Ottr.Worker, arg},
      # Start to serve requests, typically the last entry
      OttrWeb.Endpoint,
      {Registry, keys: :unique, name: TaskQueueRegistry},
      {DynamicSupervisor, strategy: :one_for_one, name: TaskQueueSupervisor},
      :poolboy.child_spec(
        :task_worker_pool,
        name: {:local, :task_worker_pool},
        worker_module: Ottr.Workers.Worker,
        size: 5,
        max_overflow: 2
      ),
      Ottr.Schedulers.Scheduler
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
      &Ottr.Telemetry.Logger.handle_event/4,
      nil
    )

    opts = [strategy: :one_for_one, name: Ottr.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OttrWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
