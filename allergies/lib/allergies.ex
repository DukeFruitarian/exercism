defmodule Allergies do
  @doc """
  List the allergies for which the corresponding flag bit is true.
  """
  @allergic_map %{
    0 => "eggs",
    1 => "peanuts",
    2 => "shellfish",
    3 => "strawberries",
    4 => "tomatoes",
    5 => "chocolate",
    6 => "pollen",
    7 => "cats"
  }

  @spec list(non_neg_integer) :: [String.t()]
  def list(flags) do
    Integer.to_string(flags, 2)
    |> String.reverse()
    |> String.codepoints()
    |> Stream.take(map_size(@allergic_map))
    |> Stream.with_index()
    |> Enum.reduce([], &check_allergy/2)
  end

  defp check_allergy({"0", _index}, allergies_list), do: allergies_list
  defp check_allergy({"1", index}, allergies_list), do: [@allergic_map[index] | allergies_list]

  @doc """
  Returns whether the corresponding flag bit in 'flags' is set for the item.
  """
  @spec allergic_to?(non_neg_integer, String.t()) :: boolean
  def allergic_to?(flags, item) do
    list(flags) |> Enum.member?(item)
  end
end
