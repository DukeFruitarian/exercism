defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency([], _), do: %{}

  def frequency(texts, workers) do
    letters =
      Enum.join(texts)
      |> String.replace(~r/[^\p{L}]/u, "")
      |> String.downcase()
      |> String.graphemes()

    letters
    |> Enum.chunk_every(div(length(letters), workers) + 1)
    |> Enum.map(&spawn_counter/1)
    |> Enum.map(fn _ ->
      receive do
        {:calculation_result, value} ->
          value
      end
    end)
    |> compose_results
  end

  defp spawn_counter(list) do
    parent = self()

    spawn(fn ->
      result = calculate_frequency(list, %{})
      send(parent, {:calculation_result, result})
    end)
  end

  defp compose_results(maps_list) do
    Enum.reduce(maps_list, %{}, fn result_part, total_result ->
      Map.merge(total_result, result_part, fn _, v1, v2 -> v1 + v2 end)
    end)
  end

  defp calculate_frequency([], result), do: result

  defp calculate_frequency([h | t], result) do
    calculate_frequency(t, Map.update(result, h, 1, &(&1 + 1)))
  end
end
