defmodule Words do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    Regex.scan(~r/[[:alnum:]-]+/u, sentence)
    |> Enum.reduce(%{}, fn [word], acc ->
      Map.update(acc, String.downcase(word), 1, &(&1 + 1))
    end)
  end
end
