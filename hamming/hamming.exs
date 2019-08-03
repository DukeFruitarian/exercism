defmodule DNA do
  @spec hamming_distance([char], [char]) :: non_neg_integer
  def hamming_distance(s1, s2) when length(s1) != length(s2), do: nil
  def hamming_distance(s1, s2), do: calculate(s1, s2, 0)

  defp calculate([], [], diff), do: diff
  defp calculate([nuc | t1], [nuc | t2], diff), do: calculate(t1, t2, diff)
  defp calculate([_h1 | t1], [_h2 | t2], diff), do: calculate(t1, t2, diff + 1)
end