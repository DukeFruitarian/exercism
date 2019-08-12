defmodule Grains do
  @doc """
  Calculate two to the power of the input minus one.
  """
  @spec square(pos_integer) :: pos_integer
  def square(1), do: 1
  def square(number), do: square(number - 1) * 2

  @doc """
  Adds square of each number from 1 to 64.
  """
  @spec total :: pos_integer
  # def total, do: Enum.reduce(1..64, &(square(&1) + &2))
  def total do
    Enum.reduce(2..64, {1, 1}, fn _, {quantity, acc} ->
      {quantity * 2, quantity * 2 + acc}
    end)
    |> elem(1)
  end
end