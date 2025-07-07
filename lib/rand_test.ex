
# todo: remove this - testing

defmodule Ottr.RandTest do
  @spec validate_balanced(String.t()) :: boolean()
  def validate_balanced(expr) do
    # ((hello))
    # true
    expr |> tokenize() |> List.flatten() |> evaluate()
  end

  defp tokenize(expr) do
    Regex.scan(~r/[\w\.]+|==|!=|>=|<=|>|<|and|or|true|false|"[^"]*"|\(|\)/, expr)
  end

  defp evaluate(tokens) do
    Enum.reduce_while(tokens, 0, fn
      "(", acc ->
        {:cont, acc + 1}

      ")", acc ->
        if acc - 1 < 0 do
          {:halt, :unbalanced}
        else
          {:cont, acc - 1}
        end

      _, acc ->
        {:cont, acc}
    end)
    |> case do
      0 -> eval(tokens)
      _ -> false
    end
  end

  def eval(tokens) do
    Enum.reduce_while(tokens, [], fn "(", acc ->
      {:cont, acc}
      ")", acc ->
        {:halt, acc}
      val, acc ->
        [val | acc]
    end)
  end
end
