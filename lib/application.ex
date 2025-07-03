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

    opts = [strategy: :one_for_one, name: Ottr.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
