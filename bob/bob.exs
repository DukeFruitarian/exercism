defmodule Bob do
  @doc """
  Answers to given message
  """
  @spec hey(String.t) :: String.t
  def hey(input) do
    determine_message(input)
    |>answer
  end

  defp determine_message(input) do
    cond do
      input =~ ~r/\A\s*\z/            -> :significant_silence
      String.ends_with?(input, ["?"]) -> :question
      input == String.upcase(input) &&
        input =~ ~r/[[:alpha:]]/      -> :yell

      true                            -> :other
    end
  end

  defp answer(:question),             do: "Sure."
  defp answer(:yell),                 do: "Whoa, chill out!"
  defp answer(:significant_silence),  do: "Fine. Be that way!"
  defp answer(_),                     do: "Whatever."
end