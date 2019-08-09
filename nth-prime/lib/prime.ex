defmodule Prime do
  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(count) when count > 0 do
    do_calculate(count - 1, [2], 3)
  end

  defp do_calculate(0, [prime | _primes], _number_to_check), do: prime

  defp do_calculate(count, primes, number_to_check) do
    case Enum.any?(primes, &(rem(number_to_check, &1) == 0)) do
      false -> do_calculate(count - 1, [number_to_check | primes], number_to_check + 1)
      _ -> do_calculate(count, primes, number_to_check + 1)
    end
  end
end
