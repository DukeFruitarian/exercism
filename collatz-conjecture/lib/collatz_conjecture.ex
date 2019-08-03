defmodule CollatzConjecture do
  @doc """
  calc/1 takes an integer and returns the number of steps required to get the
  number to 1 when following the rules:
    - if number is odd, multiply with 3 and add 1
    - if number is even, divide by 2
  """
  @spec calc(input :: pos_integer()) :: non_neg_integer()
  def calc(value) when not is_integer(value) or value <= 0, do: raise(FunctionClauseError)
  def calc(number), do: calc(number, 0)
  def calc(1, step), do: step
  def calc(number, step) when rem(number, 2) == 0, do: calc(div(number, 2), step + 1)
  def calc(number, step), do: calc(number * 3 + 1, step + 1)
end
