defmodule PascalsTriangle do
  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(num) do
    Enum.reduce(1..num, [], &row/2)
    |> Enum.reverse()
  end

  defp row(1, acc), do: [[1]]

  defp row(number, [last_row | _previous_rows] = acc) do
    current_row =
      last_row
      |> Enum.flat_map_reduce(0, fn el, last_element ->
        {[el + last_element], el}
      end)
      |> elem(0)
      |> List.insert_at(-1, 1)

    [current_row | acc]
  end
end
