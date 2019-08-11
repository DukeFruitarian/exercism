defmodule AllYourBase do
  @doc """
  Given a number in base a, represented as a sequence of digits, converts it to base b,
  or returns nil if either of the bases are less than 2
  """
  defguard are_valid_bases(base_a, base_b) when base_b >= 2 and base_a >= 2
  defguard is_digit_valid(digit, base) when digit >= 0 and digit < base
  @spec convert(list, integer, integer) :: list
  def convert(_digits, base_a, base_b) when not are_valid_bases(base_a, base_b), do: nil

  def convert([], _base_a, _base_b), do: nil

  def convert(digits, base_a, base_b) do
    decimal_number =
      Enum.reverse(digits)
      |> do_convert(base_a, 0, 0)

    decimal_number && Integer.digits(decimal_number, base_b)
  end

  defp do_convert([], _base_a, result, _pow_level), do: trunc(result)

  defp do_convert([digit | rest_digits], base_a, result, pow_level)
       when is_digit_valid(digit, base_a) do
    do_convert(rest_digits, base_a, :math.pow(base_a, pow_level) * digit + result, pow_level + 1)
  end

  defp do_convert(_digits, _base_a, _base_b, _result), do: nil
end
