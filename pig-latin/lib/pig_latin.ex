defmodule PigLatin do
  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.

  Words beginning with consonants should have the consonant moved to the end of
  the word, followed by "ay".

  Words beginning with vowels (aeiou) should have "ay" added to the end of the
  word.

  Some groups of letters are treated like consonants, including "ch", "qu",
  "squ", "th", "thr", and "sch".

  Some groups are treated like vowels, including "yt" and "xr".
  """
  @vowels ~w(a e i o u)

  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    String.split(phrase)
    |> Stream.map(&piggy_word/1)
    |> Enum.join(" ")
  end

  defp piggy_word(<<prefix::binary-2, rest::binary>>) when prefix == "qu" do
    piggy_word("#{rest}#{prefix}")
  end

  defp piggy_word(<<consonant::binary-1, prefix::binary-1, rest::binary>>)
       when consonant in ~w(x y) and prefix not in @vowels do
    "#{consonant}#{prefix}#{rest}ay"
  end

  defp piggy_word(<<prefix::binary-1, rest::binary>>) when prefix in @vowels do
    "#{prefix}#{rest}ay"
  end

  defp piggy_word(<<prefix::binary-1, rest::binary>>), do: piggy_word("#{rest}#{prefix}")
end
