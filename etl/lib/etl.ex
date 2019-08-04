defmodule ETL do
  @doc """
  Transform an index into an inverted index.

  ## Examples

  iex> ETL.transform(%{"a" => ["ABILITY", "AARDVARK"], "b" => ["BALLAST", "BEAUTY"]})
  %{"ability" => "a", "aardvark" => "a", "ballast" => "b", "beauty" =>"b"}
  """
  @spec transform(map) :: map
  def transform(input) do
    Enum.map(input, &actual_transform/1)
    |> List.flatten()
    |> Map.new()
  end

  defp actual_transform({id, words_list}) do
    Enum.map(words_list, &{String.downcase(&1), id})
  end
end
