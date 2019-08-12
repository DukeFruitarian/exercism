defmodule Grains do
  @doc """
  Calculate two to the power of the input minus one.
  """
  @spec square(pos_integer) :: pos_integer
  def square(number) when number < 1 or number > 64 do
    {:error, "The requested square must be between 1 and 64 (inclusive)"}
  end

  def square(number), do: {:ok, do_square(number)}

  defp do_square(number), do: trunc(:math.pow(2, number - 1))

  @doc """
  Adds square of each number from 1 to 64.
  """
  @spec total :: pos_integer
  def total do
    {:ok, Stream.map(1..64, &do_square/1) |> Enum.sum()}
  end
end
