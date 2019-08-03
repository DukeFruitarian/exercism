defmodule ListOps do
  # Please don't use any external modules (especially List) in your
  # implementation. The point of this exercise is to create these basic functions
  # yourself.
  #
  # Note that `++` is a function from an external module (Kernel, which is
  # automatically imported) and so shouldn't be used either.

  @spec count(list) :: non_neg_integer
  def count(list) do
    reduce(list, 0, fn _el, acc -> acc + 1 end)
  end

  @spec reverse(list) :: list
  def reverse(list), do: reduce(list, [], &[&1 | &2])

  @spec map(list, (any -> any)) :: list
  def map(list, fun) do
    reduce(list, [], &[fun.(&1) | &2])
    |> reverse
  end

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(list, fun) do
    reduce(list, [], fn el, acc -> if fun.(el), do: [el | acc], else: acc end)
    |> reverse
  end

  @type acc :: any
  @spec reduce(list, acc, ((any, acc) -> acc)) :: acc
  def reduce([], acc, _), do: acc
  def reduce([h | t], acc, fun), do: reduce(t, fun.(h, acc), fun)

  @spec append(list, list) :: list
  def append(a, b), do: concat([a, b])

  @spec concat([[any]]) :: [any]
  def concat(list_of_lists) do
    reduce(list_of_lists, [], fn inner_list, outer_acc ->
      reduce(inner_list, outer_acc, &[&1 | &2])
    end)
    |> reverse
  end
end