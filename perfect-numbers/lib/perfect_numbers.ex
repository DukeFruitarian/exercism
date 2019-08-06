defmodule PerfectNumbers do
  @doc """
  Determine the aliquot sum of the given `number`, by summing all the factors
  of `number`, aside from `number` itself.

  Based on this sum, classify the number as:

  :perfect if the aliquot sum is equal to `number`
  :abundant if the aliquot sum is greater than `number`
  :deficient if the aliquot sum is less than `number`
  """
  @spec classify(number :: integer) :: {:ok, atom} | {:error, String.t()}
  def classify(number) when number <= 0 do
    {:error, "Classification is only possible for natural numbers."}
  end

  def classify(number) do
    get_result(factors_sum(number), number)
  end

  defp factors_sum(number) do
    max_factor = :math.sqrt(number) |> Float.round() |> trunc()

    factors =
      for factor <- 1..max_factor,
          rem(number, factor) == 0,
          do: factors_for(number, factor)

    List.flatten(factors)
    |> Enum.sum()
  end

  defp get_result(a, a), do: {:ok, :perfect}
  defp get_result(a, b) when a > b, do: {:ok, :abundant}
  defp get_result(_, _), do: {:ok, :deficient}

  defp factors_for(number, number), do: []
  defp factors_for(_, 1), do: 1
  defp factors_for(number, factor) when factor * factor == number, do: [factor]
  defp factors_for(number, factor), do: [factor, div(number, factor)]
end
