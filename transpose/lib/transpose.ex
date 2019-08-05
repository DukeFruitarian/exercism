defmodule Transpose do
  @doc """
  Given an input text, output it transposed.

  Rows become columns and columns become rows. See https://en.wikipedia.org/wiki/Transpose.

  If the input has rows of different lengths, this is to be solved as follows:
    * Pad to the left with spaces.
    * Don't pad to the right.

  ## Examples
  iex> Transpose.transpose("ABC\nDE")
  "AD\nBE\nC"

  iex> Transpose.transpose("AB\nDEF")
  "AD\nBE\n F"
  """

  @spec transpose(String.t()) :: String.t()
  def transpose(""), do: ""

  def transpose(input) do
    String.split(input, "\n")
    |> Enum.map(&String.graphemes/1)
    |> normalize
    |> List.zip()
    |> Stream.map(&Tuple.to_list/1)
    |> Stream.map(fn sublist ->
      Enum.reverse(sublist)
      |> remove_fillers([])
    end)
    |> Stream.map(&Enum.join/1)
    |> Stream.reject(&(&1 == ""))
    |> Enum.join("\n")
  end

  defp normalize(list) do
    max_length = max_dimension_length(list)

    Enum.reverse(list)
    |> shuffle_list_till_size(max_length, [])
    |> Enum.reverse()
    |> Enum.map(fn sublist ->
      Enum.reverse(sublist)
      |> shuffle_list_till_size(max_length, nil)
      |> Enum.reverse()
    end)
  end

  # [["A", "B"], []]
  defp shuffle_list_till_size(list, size, _) when length(list) >= size, do: list

  defp shuffle_list_till_size(list, size, filler) do
    shuffle_list_till_size([filler | list], size, filler)
  end

  defp max_sub_list_length(list) do
    Enum.max_by(list, &length/1)
    |> length()
  end

  defp max_dimension_length(list) do
    Enum.max([max_sub_list_length(list), length(list)])
  end

  defp remove_fillers([], result) do
    result
  end

  defp remove_fillers([nil | t], result) when length(result) == 0 do
    remove_fillers(t, result)
  end

  defp remove_fillers([nil | t], result), do: remove_fillers(t, [" " | result])
  defp remove_fillers([h | t], result), do: remove_fillers(t, [h | result])
end
