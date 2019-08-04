defmodule Binary do
  @doc """
  Convert a string containing a binary number to an integer.

  On errors returns 0.
  """
  @spec to_decimal(String.t) :: non_neg_integer
  def to_decimal(string) do
    case String.replace(string, ~r/[^10]/, "") do
      ^string -> String.reverse(string) |> transfer(0)
      _ -> 0
    end
  end

  defp transfer("", _), do: 0
  defp transfer(<<byte::utf8, rest::binary>>, ex) do
    :math.pow(2, ex) * (byte - ?0) + transfer(rest, ex + 1)
  end
end