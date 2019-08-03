defmodule BracketPush do
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t) :: boolean
  def check_brackets(str) do
    process_string([], String.graphemes(str))
  end

  defp process_string(stack, []) do
    stack == []
  end

  defp process_string(stack, [ grapheme | t_string]) do
    cond do
      opening_bracket?(grapheme) ->
        process_string([grapheme | stack], t_string)
      closing_bracket?(grapheme) ->
        if stack != [] do
          [h_stack | t_stack] = stack
          if brackets_map[h_stack] == grapheme do
            process_string(t_stack, t_string)
          end
        end
      true ->
        process_string(stack, t_string)
    end
  end

  defp brackets_map do
    %{
      "{" => "}",
      "[" => "]",
      "(" => ")"
    }
  end

  def opening_bracket?(grapheme) do
    Map.has_key?(brackets_map, grapheme)
  end

  def closing_bracket?(grapheme) do
    Map.values(brackets_map)
    |> Enum.member?(grapheme)
  end
end