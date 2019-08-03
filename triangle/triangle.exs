defmodule Triangle do
  @type kind :: :equilateral | :isosceles | :scalene

  @doc """
  Return the kind of triangle of a triangle with 'a', 'b' and 'c' as lengths.
  """
  @spec kind(number, number, number) :: { :ok, kind } | { :error, String.t }
  def kind(a, b, c) do
    Enum.sort([a, b, c])
    |> triangle_type
  end

  defp triangle_type([a, _, _]) when a <= 0, do: {:error, "all side lengths must be positive"}
  defp triangle_type([a, b, c]) when a + b <= c, do: { :error, "side lengths violate triangle inequality"}
  defp triangle_type([a, a, a]), do: { :ok, :equilateral }
  defp triangle_type([a, b, c]) when a == b or b == c, do: { :ok, :isosceles }
  defp triangle_type([_, _, _]), do: { :ok, :scalene }
end