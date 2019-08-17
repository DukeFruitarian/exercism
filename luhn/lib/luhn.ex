defmodule Luhn do
  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    number = String.replace(number, ~r/\s/, "")

    cond do
      String.match?(number, ~r/\p{L}/) -> false
      byte_size(number) < 2 -> false
      correct_sum?(number) -> true
      true -> false
    end
  end

  defp correct_sum?(number) do
    Integer.parse(number)
    |> elem(0)
    |> Integer.digits()
    |> Enum.map_every(2, &double/1)
    |> Enum.sum()
    |> rem(10) == 0
  end

  defp double(digit) when digit > 4, do: digit * 2 - 9
  defp double(digit), do: digit * 2
end
