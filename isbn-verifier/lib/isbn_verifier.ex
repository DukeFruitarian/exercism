defmodule IsbnVerifier do
  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> ISBNVerifier.isbn?("3-598-21507-X")
      true

      iex> ISBNVerifier.isbn?("3-598-2K507-0")
      false

  """
  @digits ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
  defguard is_digit(grapheme) when grapheme in @digits

  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn) do
    String.replace(isbn, ~r/(-)/, "")
    |> valid?(10, 0)
  end

  defp valid?(<<"X">>, 1, result), do: rem(result + 10, 11) == 0

  defp valid?(<<digit::binary-1>>, 1, result) when is_digit(digit) do
    rem(result + String.to_integer(digit), 11) == 0
  end

  defp valid?(<<digit::binary-1, rest::binary>>, multiplier, result) when is_digit(digit) do
    valid?(rest, multiplier - 1, result + String.to_integer(digit) * multiplier)
  end

  defp valid?(_code, _multiplier, _result), do: false
end
