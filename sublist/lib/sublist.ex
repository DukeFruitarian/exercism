defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare(a, b) do
    {sublist?(a, b), sublist?(b, a)}
    |> result
  end

  defp result({true, true}), do: :equal
  defp result({false, true}), do: :superlist
  defp result({true, false}), do: :sublist
  defp result({false, false}), do: :unequal

  defp sublist?([], _), do: true
  defp sublist?(_, []), do: false

  defp sublist?(sublist, superlist) do
    beggining_of?(sublist, superlist) || sublist?(sublist, tl(superlist))
  end

  defp beggining_of?([], _), do: true
  defp beggining_of?(_, []), do: false

  defp beggining_of?([same | sub_tail], [same | super_tail]) do
    beggining_of?(sub_tail, super_tail)
  end

  defp beggining_of?(_, _), do: false
end
