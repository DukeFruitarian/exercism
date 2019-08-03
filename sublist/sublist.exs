defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare(a, b) do
    case %{a_subset_b: sublist?(a, b), b_subset_a: sublist?(b, a)} do
      %{a_subset_b: true, b_subset_a: true}    -> :equal
      %{a_subset_b: true, b_subset_a: false}   -> :sublist
      %{a_subset_b: false, b_subset_a: true}   -> :superlist
      %{a_subset_b: false, b_subset_a: false}  -> :unequal
    end
  end

  defp sublist?([], _superlist), do: true
  defp sublist?(_sublist, []), do: false
  defp sublist?(sublist, [_head | tail] = superlist) do
    beggining_of?(sublist, superlist) || sublist?(sublist, tail)
  end

  defp beggining_of?([], _superlist), do: true
  defp beggining_of?(_sublist, []), do: false
  defp beggining_of?([ha | ta], [ha | tb]), do: beggining_of?(ta, tb)
  defp beggining_of?(_sublist, _superlist), do: false
end