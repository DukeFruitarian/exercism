defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(1), do: []

  def factors_for(number) do
    prime_factor = prime_factor(number)
    new_number = div(number, prime_factor)

    [prime_factor | factors_for(new_number)]
    |> List.flatten()
  end

  def prime_factor(number) do
    possible_factors(number)
    |> Enum.find(fn factor ->
      rem(number, factor) == 0 && is_prime?(factor)
    end) || number
  end

  def is_prime?(2), do: true

  def is_prime?(number) do
    !Enum.find(possible_factors(number), &(rem(number, &1) == 0))
  end

  def possible_factors(number) do
    2..round(:math.sqrt(number))
  end
end
