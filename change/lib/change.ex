defmodule Change do
  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """

  # def generate(_, 0), do: {:ok, []}

  # @spec generate(list, integer) :: {:ok, list} | {:error, String.t()}
  # def generate(coins, target) do
  #   res = best_choice(Enum.reverse(coins), target, [], [])

  #   case res do
  #     [] -> {:error, "cannot change"}
  #     _ -> {:ok, res}
  #   end
  # end

  # def best_choice(_, _, tmp_result, result)
  #     when length(result) > 0 and length(tmp_result) >= length(result),
  #     do: result

  # def best_choice(_, 0, tmp_result, _), do: tmp_result
  # def best_choice(_, target, _, _) when target < 0, do: []

  # def best_choice(coins, target, temp_result, result) do
  #   Enum.reduce(coins, {result, coins}, fn coin, {node_result, rest_coins} ->
  #     {best_choice(rest_coins, target - coin, [coin | temp_result], node_result), tl(rest_coins)}
  #   end)
  #   |> elem(0)
  # end
  def generate(_coins, target) when target < 0, do: {:error, "cannot change"}
  def generate(_coins, 0), do: {:ok, []}

  def generate(coins, target) do
    changes =
      1..target
      |> Enum.reduce(%{0 => []}, fn index, changes -> change_for(index, changes, coins) end)

    case Map.get(changes, target) do
      nil -> {:error, "cannot change"}
      change -> {:ok, change}
    end
  end

  def change_for(target, accumulator, coins) do
    change =
      coins
      |> Enum.filter(fn coin -> accumulator[target - coin] end)
      |> Enum.map(fn coin -> [coin | accumulator[target - coin]] end)
      |> Enum.min_by(&length/1, fn -> nil end)

    Map.put(accumulator, target, change)
  end
end
