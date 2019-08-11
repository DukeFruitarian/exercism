defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search(numbers, value) do
    do_search(Tuple.to_list(numbers), value, 0)
  end

  defp do_search([], _value, _start_index), do: :not_found

  defp do_search(numbers, value, start_index) do
    central_index = div(length(numbers), 2)

    case compare(Enum.at(numbers, central_index), value) do
      :equal ->
        {:ok, start_index + central_index}

      :more ->
        do_search(Enum.take(numbers, central_index), value, start_index)

      :less ->
        do_search(
          Enum.slice(numbers, (central_index + 1)..-1),
          value,
          start_index + central_index + 1
        )
    end
  end

  defp compare(a, a), do: :equal
  defp compare(a, b) when a > b, do: :more
  defp compare(_a, _b), do: :less
end
