defmodule SaddlePoints do
  @doc """
  Parses a string representation of a matrix
  to a list of rows
  """
  @spec rows(String.t()) :: [[integer]]
  def rows(str) do
    String.split(str, "\n")
    |> Enum.map(fn line -> String.split(line) |> Enum.map(&String.to_integer/1) end)
  end

  @doc """
  Parses a string representation of a matrix
  to a list of columns
  """
  @spec columns(String.t()) :: [[integer]]
  def columns(str) do
    rows(str) |> List.zip() |> Enum.map(&Tuple.to_list/1)
  end

  @doc """
  Calculates all the saddle points from a string
  representation of a matrix
  """
  @spec saddle_points(String.t()) :: [{integer, integer}]
  def saddle_points(str) do
    rows = rows(str)
    columns = columns(str)

    rows
    |> Stream.with_index()
    |> Enum.map(fn {row, r_index} ->
      columns
      |> Stream.with_index()
      |> Stream.filter(fn {column, c_index} ->
        check_el = Enum.at(column, r_index)

        Enum.all?(row, fn el -> el <= check_el end) &&
          Enum.all?(column, fn el -> el >= check_el end)
      end)
      |> Enum.map(fn {_, c_index} -> {r_index, c_index} end)
    end)
    |> List.flatten()
  end
end
