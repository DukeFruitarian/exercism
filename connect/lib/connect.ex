defmodule Connect do
  @doc """
  Calculates the winner (if any) of a board
  using "O" as the white player
  and "X" as the black player
  """
  @move_variants [{-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}]
  @spec result_for([String.t()]) :: :none | :black | :white
  def result_for([first_row | _other_rows] = board) do
    rows = length(board)
    columns = String.length(first_row)

    case matrixify(board) |> find_winner(rows, columns) do
      "O" -> :white
      "X" -> :black
      _ -> :none
    end
  end

  defp matrixify(board) do
    for {row, row_index} <- Stream.with_index(board),
        {el, column_index} <- String.codepoints(row) |> Stream.with_index(),
        into: %{},
        do: {{row_index, column_index}, el}
  end

  defp find_winner(matrix, rows, columns) do
    Enum.find_value(matrix, fn
      {{0, 0}, el} ->
        find_win_route(el, [{0, 0}], matrix, row: rows - 1, column: columns - 1)

      {{0, c} = indexes, el} ->
        find_win_route(el, [indexes], matrix, row: rows - 1)

      {{r, 0} = indexes, el} ->
        find_win_route(el, [indexes], matrix, column: columns - 1)

      _ ->
        nil
    end)
  end

  defp find_win_route(".", _indexes, _matrix, _destination), do: nil
  defp find_win_route(el, [{r, _} | _earlier_indexes], matrix, [{:row, r} | _]), do: el
  defp find_win_route(el, [{_, c} | _earlier_indexes], matrix, [{:column, c} | _]), do: el

  defp find_win_route(el, [{r, c} | _earlier_indexes] = indexes, matrix, destinations) do
    @move_variants
    |> Enum.find_value(fn {r_shift, c_shift} ->
      idx = {r + r_shift, c + c_shift}

      if Map.get(matrix, idx) == el && idx not in indexes do
        find_win_route(el, [idx | indexes], matrix, destinations)
      end
    end)
  end
end
