defmodule Sieve do
  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(limit) do
    3..limit
    |> Enum.reduce([2], &add_prime/2)
    |> Enum.reverse()
  end

  defp add_prime(el, acc) do
    if Enum.any?(acc, &(rem(el, &1) == 0)), do: acc, else: [el | acc]
  end
end
