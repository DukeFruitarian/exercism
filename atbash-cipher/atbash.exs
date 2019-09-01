defmodule Atbash do
  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """
  @spec encode(String.t) :: String.t
  def encode(plaintext) do
    String.replace(plaintext, ~r/[^[:alnum:]]/, "")
    |> String.downcase
    |> String.to_char_list
    |> Enum.map(&encode_char/1)
    |> List.to_string
    |> String.replace(~r/.{5}(?!\z)/, "\\0 ")
  end

  defp encode_char(char) when char >= ?a, do: ?z + ?a - char
  defp encode_char(number), do: number
end