defmodule Raindrops do
  @words %{
    3 => "Pling",
    5 => "Plang",
    7 => "Plong"
  }
  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t
  def convert(number) when rem(number, 3) == 0 or rem(number, 5) == 0 or rem(number, 7) == 0 do
    Enum.reduce([3, 5, 7], "", fn factor, acc ->
      acc <> case rem(number, factor) do
        0 -> @words[factor]
        _ -> ""
      end
    end)
  end

  def convert(number), do: "#{number}"
end