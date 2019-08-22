defmodule SimpleCipher do
  @doc """
  Given a `plaintext` and `key`, encode each character of the `plaintext` by
  shifting it by the corresponding letter in the alphabet shifted by the number
  of letters represented by the `key` character, repeating the `key` if it is
  shorter than the `plaintext`.

  For example, for the letter 'd', the alphabet is rotated to become:

  defghijklmnopqrstuvwxyzabc

  You would encode the `plaintext` by taking the current letter and mapping it
  to the letter in the same position in this rotated alphabet.

  abcdefghijklmnopqrstuvwxyz
  defghijklmnopqrstuvwxyzabc

  "a" becomes "d", "t" becomes "w", etc...

  Each letter in the `plaintext` will be encoded with the alphabet of the `key`
  character in the same position. If the `key` is shorter than the `plaintext`,
  repeat the `key`.

  Example:

  plaintext = "testing"
  key = "abc"

  The key should repeat to become the same length as the text, becoming
  "abcabca". If the key is longer than the text, only use as many letters of it
  as are necessary.
  """
  def encode(plaintext, key) do
    convert(plaintext, key, :encode)
  end

  defp convert(text, key, action) do
    String.to_charlist(text)
    |> Enum.zip(shift_values(key))
    |> Enum.map(&convert_char(&1, action))
    |> to_string()
  end

  defp shift_values(key) do
    String.to_charlist(key)
    |> Stream.map(fn key -> key - ?a end)
    |> Stream.cycle()
  end

  defp convert_char({char, _}, :encode) when char < ?a or char > ?z, do: char
  defp convert_char({char, _}, :decode) when char < ?a or char > ?z, do: char
  defp convert_char({char, shift}, :encode) when char + shift <= ?z, do: char + shift
  defp convert_char({char, shift}, :encode), do: char + shift - 26
  defp convert_char({char, shift}, :decode) when char - shift >= ?a, do: char - shift
  defp convert_char({char, shift}, :decode), do: char - shift + 26

  @doc """
  Given a `ciphertext` and `key`, decode each character of the `ciphertext` by
  finding the corresponding letter in the alphabet shifted by the number of
  letters represented by the `key` character, repeating the `key` if it is
  shorter than the `ciphertext`.

  The same rules for key length and shifted alphabets apply as in `encode/2`,
  but you will go the opposite way, so "d" becomes "a", "w" becomes "t",
  etc..., depending on how much you shift the alphabet.
  """
  def decode(ciphertext, key) do
    convert(ciphertext, key, :decode)
  end
end
