defmodule Wordy do
  @doc """
  Calculate the math problem in the sentence.
  """
  @valid_words ["plus", "minus", "divided", "multiplied"]
  @spec answer(String.t()) :: integer
  def answer(line) do
    start_parse(line)
  end

  def start_parse("What is " <> rest), do: parse(rest, "", {0, "plus"})
  def start_parse(_line), do: raise(ArgumentError)

  def parse("?", current_word, state) do
    apply_word(state, current_word)
    |> elem(0)
  end

  def parse(" " <> rest, current_word, state) do
    parse(rest, "", apply_word(state, current_word))
  end

  def parse(<<char::binary-1, rest::binary>>, current_word, state) do
    parse(rest, current_word <> char, state)
  end

  def apply_word({value, action}, "by"), do: {value, action <> " by"}
  def apply_word({value, ""}, word) when word in @valid_words, do: {value, word}
  def apply_word({value, "plus"}, word), do: {value + String.to_integer(word), ""}
  def apply_word({value, "divided by"}, word), do: {value / String.to_integer(word), ""}
  def apply_word({value, "minus"}, word), do: {value - String.to_integer(word), ""}
  def apply_word({value, "multiplied by"}, word), do: {value * String.to_integer(word), ""}
  def apply_word(_state, _word), do: raise(ArgumentError)
end
