defmodule Ottr.Utils.TemplateResolver do
  @moduledoc """
  Resolves {{variables}} in step args using a provided context map.
  """

  @regex ~r/\{\{(\w+)\}\}/

  def interpolate(map, context) when is_map(map) do
    Enum.reduce(map, %{}, fn {key, value}, acc ->
      Map.put(acc, key, interpolate_value(value, context))
    end)
  end

  # skip interpolation for types that don't need it
  defp interpolate_value(value, _context) when is_map(value), do: value
  defp interpolate_value(value, _context) when is_integer(value), do: value
  defp interpolate_value(value, _context) when is_boolean(value), do: value
  defp interpolate_value(value, _context) when is_nil(value), do: nil

  defp interpolate_value(value, context) when is_binary(value) do
    Regex.replace(@regex, value, fn _, var ->
      Map.get(context, var, "")
    end)
  end
end
