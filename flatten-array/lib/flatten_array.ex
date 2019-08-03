defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten(list) do
    do_flatten(list, [])
    |> Enum.reverse()
  end

  def do_flatten([], result), do: result

  def do_flatten([head | tail], result) when is_list(head) do
    do_flatten(tail, do_flatten(head, result))
  end

  def do_flatten([nil | tail], result), do: do_flatten(tail, result)
  def do_flatten([head | tail], result), do: do_flatten(tail, [head | result])

  # def flatten(list) do
  #   List.flatten(list)
  #   |> Enum.filter(& &1)
  # end
end
