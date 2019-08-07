defmodule Palindromes do

  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max_factor, min_factor \\ 1) do
    for first <- min_factor..max_factor,
      second <- min_factor..max_factor,
      first <= second,
      first * second |> to_string |> is_palendrome? do

      [first, second]
    end
    |> Enum.reduce(%{}, fn factors, map ->
      palindrome = Enum.reduce(factors, &*/2)
      list = Map.get(map, palindrome, [])
      |> List.insert_at(-1, factors)
      Map.put(map, palindrome, list)
    end)
  end

  defp is_palendrome?(string), do: string == String.reverse(string)
end