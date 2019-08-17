defmodule Matrix do
  @doc """
  Parses a string representation of a matrix
  to a list of rows
  """
  @spec rows(String.t()) :: [[integer]]
  def rows(str) do
    String.split(str, "\n")
    |> Enum.map(fn list ->
      String.split(list)
      |> Enum.map(&String.to_integer(&1))
    end)
  end

  @doc """
  Parses a string representation of a matrix
  to a list of columns
  """
  @spec columns(String.t()) :: [[integer]]
  def columns(str) do
    rows(str)
    |> List.zip
    |> Enum.map(&Tuple.to_list(&1))
  end

  @doc """
  Calculates all the saddle points from a string
  representation of a matrix
  """
  @spec saddle_points(String.t()) :: [{integer, integer}]
  def saddle_points(str) do
    cols = columns(str)
    rows = rows(str)

    for {row, row_index} <- Enum.with_index(rows),
      {element, col_index} <- Enum.with_index(row),
      Enum.max(Enum.at(rows, row_index)) == element,
      Enum.min(Enum.at(cols, col_index)) == element, do: {row_index, col_index}
  end
end