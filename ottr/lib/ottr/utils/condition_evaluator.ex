defmodule Ottr.Utils.ConditionalEvaluator do
  @moduledoc "Evaluates workflow step conditions using the provided context."
  alias Ottr.Utils.ConditionParser
  require Logger
  @spec should_run?(map() | String.t() | nil, map()) :: boolean()
  def should_run?(nil, _context), do: true

  def should_run?(%{} = condition, %{} = context) when is_map(condition) do
    Enum.all?(condition, fn
      {key, expected_value} when is_binary(key) ->
        Map.get(context, key) == expected_value

      _ ->
        false
    end)
  end

  def should_run?(expression, %{} = context) when is_binary(expression) do
    try do
      Logger.debug("Evaluating expression using Conditional Parser: #{expression}")
      ConditionParser.eval(expression, context)
    rescue
      _ -> false
    end
  end
end
