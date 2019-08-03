defmodule Bob do
  def hey(input) do
    cond do
      empty?(input) ->
        "Fine. Be that way!"

      ends_with_question_mark?(input) && all_capitals?(input) ->
        "Calm down, I know what I'm doing!"

      all_capitals?(input) ->
        "Whoa, chill out!"

      ends_with_question_mark?(input) ->
        "Sure."

      true ->
        "Whatever."
    end
  end

  defp empty?(input), do: Regex.replace(~r/\s/, input, "") == ""
  defp ends_with_question_mark?(input), do: String.match?(input, ~r/\?\z/)
  defp all_capitals?(input), do: String.match?(input, ~r/\p{L}/) && String.upcase(input) == input
end
