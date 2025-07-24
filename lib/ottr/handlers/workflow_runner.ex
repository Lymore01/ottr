defmodule Ottr.Handlers.WorkflowRunner do
  @behaviour Ottr.Behaviours.Handlers

  alias Ottr.OttrRepo.Workflows
  alias Ottr.Utils.TemplateResolver
  alias Ottr.Utils.ConditionalEvaluator
  alias Ottr.Handlers.Handler

  def handle(%{"workflow_id" => id, "step" => step_number, "context" => context}) do
    workflow = Workflows.get_workflow!(id)
    steps = Enum.sort_by(workflow.workflow_steps, & &1.position)

    case Enum.at(steps, step_number - 1) do
      nil ->
        {:ok, workflow} = Workflows.update_workflow(workflow, %{started_at: DateTime.utc_now()})
        {:ok, workflow}

      step ->
        if step_number == 1 && is_nil(workflow.started_at) do
          {:ok, _workflow} =
            Workflows.update_workflow(workflow, %{started_at: DateTime.utc_now()})
        end

        if ConditionalEvaluator.should_run?(step.condition, context) do
          handler = Handler.resolve_handler(step.type)
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

                {:ok, workflow}
              else
                # the last step
                {:ok, completed_workflow} =
                  Workflows.update_workflow(workflow, %{finished_at: DateTime.utc_now()})

                {:done, completed_workflow}
              end

            {:error, reason} ->
              {:error, reason}
          end
        else
          # condition not met, skip to next step
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

          {:ok, workflow}
        end
    end
  end
end
