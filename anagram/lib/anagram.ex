defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    Enum.filter(candidates, fn candidate ->
      decomposed(base) == decomposed(candidate) &&
        String.downcase(base) != String.downcase(candidate)
    end)
  end

  defp decomposed(string) do
    string
    |> String.downcase()
    |> String.to_charlist()
    |> Enum.sort()
  end
end
