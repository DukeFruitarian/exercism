defmodule Series do
  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t(), non_neg_integer) :: non_neg_integer
  def largest_product(_, size) when size < 0, do: raise(ArgumentError)
  def largest_product(string, size) when size > byte_size(string), do: raise(ArgumentError)
  def largest_product(_, 0), do: 1

  def largest_product(number_string, size) do
    String.codepoints(number_string)
    |> Stream.map(&String.to_integer/1)
    |> Stream.chunk_every(size, 1, :discard)
    |> Enum.max_by(fn chunk -> Enum.reduce(chunk, 1, &*/2) end)
    |> Enum.reduce(1, &*/2)
  end
end
