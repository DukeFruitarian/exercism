defmodule Sieve do

  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(limit) do
    2..limit
    |> Enum.to_list
    |> get_primes
  end

  defp get_primes([]), do: []
  defp get_primes([prime | tail]) do
    [prime | get_primes(Enum.reject(tail, &(rem(&1, prime) == 0)))]
  end
end