defmodule ETL do
  @doc """
  Transform an index into an inverted index.

  ## Examples

  iex> ETL.transform(%{"a" => ["ABILITY", "AARDVARK"], "b" => ["BALLAST", "BEAUTY"]})
  %{"ability" => "a", "aardvark" => "a", "ballast" => "b", "beauty" =>"b"}
  """
  @spec transform(map) :: map
  def transform(input) do
    Enum.map(input, fn {char, words_list} ->
      Enum.map(words_list, fn word ->
        {String.downcase(word), char}
      end)
    end)
    |> List.flatten
    |> Enum.into(%{})
  end
end