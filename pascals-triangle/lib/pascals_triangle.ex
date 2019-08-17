defmodule PascalsTriangle do
  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(num) do
    Enum.reduce(1..num, [], fn _, last_row -> row(last_row) end)
    |> Enum.reverse()
  end

  defp row([]), do: [[1]]

  defp row([last_row | _previous_rows] = acc) do
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
