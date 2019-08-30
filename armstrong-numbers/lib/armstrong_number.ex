defmodule ArmstrongNumber do
  @moduledoc """
  Provides a way to validate whether or not a number is an Armstrong number
  """

  @spec valid?(integer) :: boolean
  def valid?(number) do
    digits = Integer.digits(number)
    pow_factor = length(digits)

    digits
    |> Stream.map(fn digit -> {digit, pow_factor} end)
    |> Enum.reduce(0, &do_calculate/2) == number
  end

  defp do_calculate({digit, pow_factor}, sum) do
    :math.pow(digit, pow_factor) + sum
  end
end
