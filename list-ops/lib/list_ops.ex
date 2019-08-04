defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(l), do: do_count(l, 0)

  defp do_count([], size), do: size
  defp do_count([_ | t], size), do: do_count(t, size + 1)

  @spec reverse(list) :: list
  def reverse(l), do: do_reverse(l, [])

  defp do_reverse([], reversed), do: reversed
  defp do_reverse([h | t], reversed), do: do_reverse(t, [h | reversed])

  @spec map(list, (any -> any)) :: list
  def map(l, f), do: do_map(l, f, [])

  def do_map([], _, result), do: reverse(result)
  def do_map([h | t], f, result), do: do_map(t, f, [f.(h) | result])

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f), do: do_filter(l, f, [])

  def do_filter([], _, result), do: reverse(result)

  def do_filter([h | t], f, result) do
    case f.(h) do
      false -> do_filter(t, f, result)
      true -> do_filter(t, f, [h | result])
    end
  end

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc

  def reduce([], acc, _), do: acc
  def reduce([h | t], acc, f), do: reduce(t, f.(h, acc), f)

  @spec append(list, list) :: list
  def append(a, b), do: do_append(reverse(a), b)

  defp do_append([], b), do: b
  defp do_append([h | t], b), do: do_append(t, [h | b])

  @spec concat([[any]]) :: [any]
  def concat(ll), do: do_concat(ll, [])

  def do_concat([], result), do: reverse(result)
  def do_concat([hl | tl], result), do: do_concat(tl, append(reverse(hl), result))
end
