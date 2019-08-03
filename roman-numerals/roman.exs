defmodule Roman do
  @numbers [
    {1000, "M"}, {900, "CM"}, {500, "D"}, {400, "CD"}, {100, "C"}, {90, "XC"},
    {50, "L"}, {40, "XL"}, {10, "X"}, {9, "IX"}, {5, "V"}, {4, "IV"}, {1, "I"}
  ]
  @spec numerals(pos_integer) :: String.t
  def numerals(number) do
    Enum.reduce(@numbers, {"", number}, fn {dec, rom}, {target, reminder} ->
      {
        target <> String.duplicate(rom, div(reminder, dec)),
        rem(reminder, dec)
      }
    end)
    |> elem(0)
  end
end