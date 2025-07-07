# user.age >= 18 and (user.verified == true or user.admin == true)

defmodule Ottr.Utils.ConditionParser do
  @type context :: map()
  @type expression :: String.t()

  # tokenize
  @spec eval(expression(), context()) :: boolean()
  def eval(expression, context) do
    expression
    |> tokenize
    |> parse_tokens
    |> evaluate(context)
  end

  # tokenize the expression
  def tokenize(expr) do
    Regex.scan(~r/[\w\.]+|==|!=|>=|<=|>|<|and|or|true|false|"[^"]*"|\(|\)/, expr)
    |> List.flatten()
    |> Enum.map(&normalize_token/1)
  end

  defp normalize_token(token) do
    cond do
      token == "true" -> true
      token == "false" -> false
      token == "and" -> :and
      token == "or" -> :or
      Regex.match?(~r/^"[^"]*"$/, token) -> String.trim(token, "\"")
      Regex.match?(~r/^\d+$/, token) -> String.to_integer(token)
      Regex.match?(~r/^\d+\.\d+$/, token) -> String.to_float(token)
      true -> token
    end
  end

  # parse tokens
  defp parse_tokens(tokens) do
    parse_expr(tokens)
  end

  defp parse_expr([left, op, right | rest]) when op in ["==", "!=", ">", "<", ">=", "<="] do
    left_expr = {:comp, op, left, right}

    case rest do
      [:and | tail] ->
        {:and, left_expr, parse_expr(tail)}

      [:or | tail] ->
        {:or, left_expr, parse_expr(tail)}

      ["(" | _] ->
        {inner, remaining} = extract_group(rest)
        parsed_inner = parse_expr(inner)
        parse_expr([parsed_inner | remaining])

      [] ->
        left_expr

      _ ->
        raise "Unsupported expression format: #{inspect(rest)}"
    end
  end

  defp parse_expr(["(" | _] = tokens) do
    {inner_tokens, rest} = extract_group(tokens)
    grouped_expr = parse_expr(inner_tokens)
    parse_expr([grouped_expr | rest])
  end

  defp parse_expr([left, :and, right]), do: {:and, left, parse_expr([right])}
  defp parse_expr([left, :or, right]), do: {:or, left, parse_expr([right])}
  defp parse_expr([ast]) when is_tuple(ast), do: ast

  defp parse_expr([_ | _] = tokens), do: raise("Unsupported condition AST: #{inspect(tokens)}")

  defp extract_group(tokens), do: extract_group(tokens, 0, [], [])

  defp extract_group([], _, acc, rest), do: {Enum.reverse(acc), rest}

  defp extract_group(["(" | tail], 0, acc, _rest),
    do: extract_group(tail, 1, [], acc)

  defp extract_group(["(" | tail], depth, acc, rest),
    do: extract_group(tail, depth + 1, ["(" | acc], rest)

  defp extract_group([")" | tail], 1, acc, rest),
    do: {Enum.reverse(acc), tail ++ rest}

  defp extract_group([")" | tail], depth, acc, rest),
    do: extract_group(tail, depth - 1, [")" | acc], rest)

  defp extract_group([token | tail], depth, acc, rest),
    do: extract_group(tail, depth, [token | acc], rest)

  # evaluate the parsed tree
  defp evaluate({:comp, op, left, right}, context) do
    lval = resolve_value(left, context)
    rval = resolve_value(right, context)

    case op do
      "==" -> lval == rval
      "!=" -> lval != rval
      ">" -> lval > rval
      "<" -> lval < rval
      ">=" -> lval >= rval
      "<=" -> lval <= rval
    end
  end

  defp evaluate({:and, left, right}, context) do
    evaluate(left, context) and evaluate(right, context)
  end

  defp evaluate({:or, left, right}, context) do
    evaluate(left, context) or evaluate(right, context)
  end

  defp evaluate(value, _context) when is_boolean(value), do: value

  defp evaluate(token, context) do
    resolve_value(token, context)
  end

  defp resolve_value(token, context) when is_binary(token) do
    token
    |> String.split(".")
    |> Enum.reduce_while(context, fn key, acc ->
      case acc do
        %{} -> {:cont, Map.get(acc, key)}
        _ -> {:halt, nil}
      end
    end)
  end

  defp resolve_value(value, _context), do: value
end

# tokenize
# normalize
# parse expr - recurse
