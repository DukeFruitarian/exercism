defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "HORSE" => "1H1O1R1S1E"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "1H1O1R1S1E" => "HORSE"
  """
  @spec encode(String.t) :: String.t
  def encode(string) do
    chunks = Regex.scan(~r/(.)\1*/, string)
    pack("", chunks)
  end

  defp pack(result, []) do
    result
  end

  defp pack(result, [[char_line | [grapheme]] | rest]) do
    result <> "#{String.length(char_line)}#{grapheme}"
    |> pack(rest)
  end

  @spec decode(String.t) :: String.t
  def decode(string) do
    parts = Regex.scan(~r/(\d+)([[:alpha:]])/, string)
    extract("", parts)
  end

  defp extract(result, []) do
    result
  end

  defp extract(result, [[_ | [quantity | [grapheme]]] | rest]) do
    result <> String.duplicate(grapheme, String.to_integer(quantity))
    |> extract(rest)
  end
end