defmodule RotationalCipher do
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    to_charlist(text)
    |> Enum.map(&transform(&1, shift))
    |> to_string
  end

  defp transform(charcode, shift) when charcode in ?a..?z do
    ?a + rem(charcode - ?a + shift, 26)
  end

  defp transform(charcode, shift) when charcode in ?A..?Z do
    ?A + rem(charcode - ?A + shift, 26)
  end

  defp transform(charcode, _), do: charcode
end
