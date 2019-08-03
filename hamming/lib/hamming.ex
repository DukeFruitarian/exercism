defmodule Hamming do
  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> Hamming.hamming_distance('AAGTCATA', 'TAGCGATC')
  {:ok, 4}
  """
  @spec hamming_distance([char], [char]) :: {:ok, non_neg_integer} | {:error, String.t()}
  def hamming_distance(strand1, strand2) do
    distance(strand1, strand2, 0)
  end

  defp distance([], [], d), do: {:ok, d}
  defp distance([], _, _), do: {:error, "Lists must be the same length"}
  defp distance(_, [], _), do: {:error, "Lists must be the same length"}
  defp distance([h1 | t1], [h1 | t2], d), do: distance(t1, t2, d)
  defp distance([_ | t1], [_ | t2], d), do: distance(t1, t2, d + 1)
end
