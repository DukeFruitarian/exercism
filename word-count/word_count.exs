defmodule Words do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t) :: map
  def count(sentence) do
    word_list = Regex.scan(~r/[-[:alnum:]]+/u, sentence)
    calculate(%{}, word_list)
  end

  defp calculate(counts, []) do
    counts
  end

  defp calculate(counts, [[h] | t]) do
    counts
    |> Map.update(String.downcase(h), 1, &(&1 + 1))
    |> calculate(t)
  end
end