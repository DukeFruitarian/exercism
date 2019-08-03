defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t, [String.t]) :: [String.t]
  def match(base, candidates) do
    Enum.filter(candidates, fn candidate ->
      sorted_graphemes(candidate) == sorted_graphemes(base) &&
        String.downcase(candidate) != String.downcase(base)
    end)
  end

  defp sorted_graphemes(word) do
    word
    |> String.downcase
    |> String.to_char_list
    |> Enum.sort
  end
end