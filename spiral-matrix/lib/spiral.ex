defmodule Spiral do
  @doc """
  Given the dimension, return a square matrix of numbers in clockwise spiral order.
  """

  @next_direction %{
    right: :down,
    down: :left,
    left: :up,
    up: :right
  }

  defstruct result: %{{0, 0} => 1},
            direction: :right,
            counter: 1,
            last_index: {0, 0},
            dimension: 1

  @spec matrix(dimension :: integer) :: list(list(integer))
  def matrix(0), do: []

  def matrix(dimension) do
    collect_indexes(%Spiral{dimension: dimension})
    |> Enum.to_list()
    |> Stream.map(fn {_, el} -> el end)
    |> Enum.chunk_every(dimension)
  end

  defp collect_indexes(%{result: result, direction: direction, counter: counter} = spiral) do
    case next_position_in_line(spiral) do
      {:ok, new_position} ->
        collect_indexes(%{
          spiral
          | result: Map.put(result, new_position, counter + 1),
            counter: counter + 1,
            last_index: new_position
        })

      :error ->
        case next_position_in_line(%{spiral | direction: @next_direction[direction]}) do
          {:ok, new_position} ->
            collect_indexes(%{
              spiral
              | result: Map.put(result, new_position, counter + 1),
                counter: counter + 1,
                last_index: new_position,
                direction: @next_direction[direction]
            })

          :error ->
            result
        end
    end
  end

  defp next_position_in_line(%{
         result: result,
         last_index: {x, y},
         direction: :right,
         dimension: dimension
       })
       when y < dimension - 1 do
    case Map.fetch(result, {x, y + 1}) do
      {:ok, _} -> :error
      :error -> {:ok, {x, y + 1}}
    end
  end

  defp next_position_in_line(%{
         result: result,
         last_index: {x, y},
         direction: :down,
         dimension: dimension
       })
       when x < dimension - 1 do
    case Map.fetch(result, {x + 1, y}) do
      {:ok, _} -> :error
      :error -> {:ok, {x + 1, y}}
    end
  end

  defp next_position_in_line(%{
         result: result,
         last_index: {x, y},
         direction: :left
       })
       when y > 0 do
    case Map.fetch(result, {x, y - 1}) do
      {:ok, _} -> :error
      :error -> {:ok, {x, y - 1}}
    end
  end

  defp next_position_in_line(%{
         result: result,
         last_index: {x, y},
         direction: :up
       })
       when x > 0 do
    case Map.fetch(result, {x - 1, y}) do
      {:ok, _} -> :error
      :error -> {:ok, {x - 1, y}}
    end
  end

  defp next_position_in_line(_spiral), do: :error
end
