defmodule Allergies do
  @products ["eggs", "peanuts", "shellfish", "strawberries", "tomatoes",
    "chocolate",  "pollen", "cats"
  ]
  @doc """
  List the allergies for which the corresponding flag bit is true.
  """
  @spec list(non_neg_integer) :: [String.t]
  def list(flags) do
    for {product, exp} <- Enum.with_index(@products),
      rem(flags, trunc(:math.pow(2, exp + 1))) >= :math.pow(2, exp), do: product
  end

  @doc """
  Returns whether the corresponding flag bit in 'flags' is set for the item.
  """
  @spec allergic_to?(non_neg_integer, String.t) :: boolean
  def allergic_to?(flags, item) do
    list(flags)
    |> Enum.member?(item)
  end
end