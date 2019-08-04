defmodule LinkedList do
  @opaque t :: tuple()

  @doc """
  Construct a new LinkedList
  """
  @spec new() :: t
  def new() do
    nil
  end

  @doc """
  Push an item onto a LinkedList
  """
  @spec push(t, any()) :: t
  def push(list, elem), do: {elem, list}

  @doc """
  Calculate the length of a LinkedList
  """
  @spec length(t) :: non_neg_integer()
  def length(list), do: do_length(list, 0)

  def do_length(nil, size), do: size
  def do_length({_, list}, size), do: do_length(list, size + 1)

  @doc """
  Determine if a LinkedList is empty
  """
  @spec empty?(t) :: boolean()
  def empty?(nil), do: true
  def empty?(_), do: false

  @doc """
  Get the value of a head of the LinkedList
  """
  @spec peek(t) :: {:ok, any()} | {:error, :empty_list}
  def peek(nil), do: {:error, :empty_list}
  def peek({value, _}), do: {:ok, value}

  @doc """
  Get tail of a LinkedList
  """
  @spec tail(t) :: {:ok, t} | {:error, :empty_list}
  def tail(nil), do: {:error, :empty_list}
  def tail({_, list}), do: {:ok, list}

  @doc """
  Remove the head from a LinkedList
  """
  @spec pop(t) :: {:ok, any(), t} | {:error, :empty_list}
  def pop(nil), do: {:error, :empty_list}
  def pop({value, list}), do: {:ok, value, list}

  @doc """
  Construct a LinkedList from a stdlib List
  """
  @spec from_list(list()) :: t
  def from_list(list) do
    Enum.reverse(list)
    |> do_from_list(nil)
  end

  defp do_from_list([], result), do: result
  defp do_from_list([h | t], result), do: do_from_list(t, {h, result})

  @doc """
  Construct a stdlib List LinkedList from a LinkedList
  """
  @spec to_list(t) :: list()
  def to_list(list) do
    do_to_list(list, [])
    |> Enum.reverse()
  end

  defp do_to_list(nil, result), do: result
  defp do_to_list({h, t}, result), do: do_to_list(t, [h | result])

  @doc """
  Reverse a LinkedList
  """
  @spec reverse(t) :: t
  def reverse(list) do
    do_reverse(list, nil)
  end

  defp do_reverse(nil, result), do: result
  defp do_reverse({h, t}, result), do: do_reverse(t, {h, result})
end
