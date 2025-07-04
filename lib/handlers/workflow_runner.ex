defmodule Ottr.TaskHandlers.WorkflowRunner do
  @behaviour Ottr.TaskHandler
  alias OttrRepo.Workflows
  alias Ottr.Utils.TemplateResolver

  def handle(%{"workflow_id" => id, "step" => step_number, "context" => context}) do
    workflow = Workflows.get_workflow!(id)
    steps = Enum.sort_by(workflow.workflow_steps, & &1.position)

    case Enum.at(steps, step_number - 1) do
      nil ->
        :ok

      step ->
        handler = Ottr.Handlers.resolve_handler(step.type)

        resolved_args = TemplateResolver.interpolate(step.args, context)

        case handler.handle(resolved_args) do
          :ok ->
            if Enum.at(steps, step_number) do
              Ottr.insert(workflow.queue, %{
                data: %{
                  "type" => "workflow_runner",
                  "args" => %{
                    "workflow_id" => id,
                    "step" => step_number + 1,
                    "context" => context
                  }
                }
              })
            end

            :ok

          {:error, reason} ->
            {:error, reason}
        end
    end
  end
end
