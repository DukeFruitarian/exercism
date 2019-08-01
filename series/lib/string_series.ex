defmodule StringSeries do
  @doc """
  Given a string `s` and a positive integer `size`, return all substrings
  of that size. If `size` is greater than the length of `s`, or less than 1,
  return an empty list.
  """
  @spec slices(s :: String.t(), size :: integer) :: list(String.t())
  def slices(s, size) do
    do_slice(s, size, [])
    |> Enum.reverse()
  end

  defp do_slice(_, size, result) when size <= 0, do: result

  defp do_slice(s, size, result) do
    cond do
      String.length(s) < size -> result
      true -> do_slice(String.slice(s, 1..-1), size, [String.slice(s, 0..(size - 1)) | result])
    end
  end
end
