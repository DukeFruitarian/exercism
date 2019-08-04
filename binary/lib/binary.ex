defmodule Binary do
  @doc """
  Convert a string containing a binary number to an integer.

  On errors returns 0.
  """
  @spec to_decimal(String.t()) :: non_neg_integer
  def to_decimal(string) do
    if String.match?(string, ~r/[^01]/) do
      0
    else
      String.graphemes(string)
      |> Enum.reverse()
      |> Enum.with_index()
      |> Stream.map(&translate/1)
      |> Enum.sum()
    end
  end

  defp translate({"1", digit_number}), do: :math.pow(2, digit_number)
  defp translate(_), do: 0
end
