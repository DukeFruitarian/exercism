defmodule Raindrops do
  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t()
  def convert(number) do
    do_convert(number, "", %{3 => false, 5 => false, 7 => false})
  end

  defp do_convert(number, result, state = %{3 => false}) when rem(number, 3) == 0 do
    do_convert(div(number, 3), "#{result}Pling", %{state | 3 => true})
  end

  defp do_convert(number, result, state = %{5 => false}) when rem(number, 5) == 0 do
    do_convert(div(number, 5), "#{result}Plang", %{state | 5 => true})
  end

  defp do_convert(number, result, state = %{7 => false}) when rem(number, 7) == 0 do
    do_convert(div(number, 7), "#{result}Plong", %{state | 7 => true})
  end

  defp do_convert(number, "", _), do: to_string(number)
  defp do_convert(_, result, _), do: result
end
