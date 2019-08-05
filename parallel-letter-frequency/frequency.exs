defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a dict of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t], pos_integer) :: map
  def frequency(texts, workers) do
    text = Enum.reduce(texts, "", &<>/2)
    |> String.replace(~r/[^[:alpha:]]/u, "")
    |> String.downcase

    letters_count = div(String.length(text), workers) + 1
    parent_pid = self

    0..(workers-1)
    |> Enum.each(fn worker_number ->
      substring = String.slice(text, letters_count * worker_number, letters_count)
      spawn_link(fn ->
        send(parent_pid, {:result, calculate(substring)})
      end)
    end)


    1..workers
    |> Enum.reduce(%{}, fn idx, result ->
      receive do
        {:result, map} ->
          Map.merge(result, map, fn _k, v1, v2 -> v1 + v2 end)
      end
    end)
  end

  defp calculate(string) do
    string
    |> String.graphemes
    |> Enum.reduce(%{}, fn grapheme, result ->
      Map.update(result, grapheme, 1, &(&1 + 1))
    end)
  end
end