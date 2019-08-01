defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(string) :: String.t()
  def abbreviate(string) do
    words = Regex.scan(~r/(\A[[:alpha:]]|[A-Z]|\b[[:alpha:]])[a-z]*/, string)
    construct("", words)
  end

  defp construct(abbreviation, []) do
    abbreviation
  end

  defp construct(abbreviation, [[_ | [grapheme]] | words_left]) do
    abbreviation <> String.upcase(grapheme)
    |> construct(words_left)
  end
end