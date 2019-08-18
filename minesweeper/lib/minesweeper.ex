defmodule Minesweeper do
  @doc """
  Annotate empty spots next to mines with the number of mines next to them.
  """
  @nearby_indexes_shift [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]
  @spec annotate([String.t()]) :: [String.t()]

  def annotate([]), do: []

  def annotate([first_row | _other_rows] = board) do
    map =
      for {row, row_index} <- Enum.with_index(board),
          {el, column_index} <- String.codepoints(row) |> Enum.with_index(),
          into: %{},
          do: {{row_index, column_index}, el}

    transformed_map = Enum.reduce(map, %{}, &accumulate(&1, &2, map))

    0..(length(board) - 1)
    |> Enum.map(fn row ->
      0..(String.length(first_row) - 1)
      |> Enum.map_join(&Map.get(transformed_map, {row, &1}))
    end)
  end

  defp accumulate({indexes, "*"}, acc, _initial_map), do: Map.put(acc, indexes, "*")

  defp accumulate({indexes, " "}, acc, initial_map) do
    value =
      case(calculate_surrounded_mines(indexes, initial_map)) do
        0 -> " "
        value -> value
      end

    Map.put(acc, indexes, value)
  end

  defp calculate_surrounded_mines({row, column}, initial_map) do
    Enum.count(@nearby_indexes_shift, fn {row_shift, column_shift} ->
      Map.get(initial_map, {row + row_shift, column + column_shift}) == "*"
    end)
  end
end
