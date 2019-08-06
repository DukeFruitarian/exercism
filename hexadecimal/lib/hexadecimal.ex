defmodule Hexadecimal do
  @doc """
    Accept a string representing a hexadecimal value and returns the
    corresponding decimal value.
    It returns the integer 0 if the hexadecimal is invalid.
    Otherwise returns an integer representing the decimal value.

    ## Examples

      iex> Hexadecimal.to_decimal("invalid")
      0

      iex> Hexadecimal.to_decimal("af")
      175

  """
  @hexadecimals %{
    "0" => 0,
    "1" => 1,
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "a" => 10,
    "b" => 11,
    "c" => 12,
    "d" => 13,
    "e" => 14,
    "f" => 15
  }

  @spec to_decimal(binary) :: integer
  def to_decimal(hex) do
    String.downcase(hex)
    |> String.graphemes()
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce({:ok, 0}, &calculate/2)
    |> elem(1)
  end

  def calculate({_, _}, {:error, _}), do: {:error, 0}

  def calculate({hex_digit, index}, {:ok, sum}) do
    case Map.get(@hexadecimals, hex_digit) do
      nil -> {:error, 0}
      decimal -> {:ok, sum + decimal * :math.pow(16, index)}
    end
  end
end
