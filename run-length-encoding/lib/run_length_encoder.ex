defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(string) do
    do_encode(string, nil, 0, "")
  end

  @spec decode(String.t()) :: String.t()
  def decode(string) do
    Regex.replace(
      ~r/[\d]+./,
      string,
      fn x, _ ->
        {quantity, letter} = Integer.parse(x)
        String.duplicate(letter, quantity)
      end
    )
  end

  # ""replacement, options \\ [])
  defp do_encode("", _, 0, _), do: ""

  defp do_encode("", prev_letter, quantity, decoded) when quantity > 1 do
    "#{decoded}#{quantity}#{prev_letter}"
  end

  defp do_encode("", prev_letter, _, decoded), do: "#{decoded}#{prev_letter}"

  defp do_encode(<<next_letter::binary-1, rest::binary>>, prev_letter, quantity, decoded)
       when next_letter == prev_letter do
    do_encode(rest, prev_letter, quantity + 1, decoded)
  end

  defp do_encode(<<next_letter::binary-1, rest::binary>>, prev_letter, quantity, decoded)
       when quantity > 1 do
    do_encode(rest, next_letter, 1, "#{decoded}#{quantity}#{prev_letter}")
  end

  defp do_encode(<<next_letter::binary-1, rest::binary>>, prev_letter, _, decoded) do
    do_encode(rest, next_letter, 1, "#{decoded}#{prev_letter}")
  end
end
