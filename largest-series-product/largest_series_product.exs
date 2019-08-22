defmodule Series do

  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t, non_neg_integer) :: non_neg_integer
  def largest_product("", 0), do: 1
  def largest_product("", _number), do: raise ArgumentError
  def largest_product(_string, number) when number < 0, do: raise ArgumentError

  def largest_product(number_string, 0) do
    number_string
    |> String.at(0)
    |> String.to_integer
  end

  def largest_product(number_string, size) do
    if String.length(number_string) < size, do: raise ArgumentError

    0..(String.length(number_string) - size)
    |> Stream.map(fn index ->
      String.slice(number_string, index, size)
      |> String.graphemes
      |> Stream.map(&String.to_integer/1)
      |> Enum.reduce(&(&1 * &2))
    end)
    |> Enum.max
  end
end