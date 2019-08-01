defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t()) :: boolean
  def isogram?(sentence) do
    letters = Regex.scan(~r/\p{L}/, sentence)
    Enum.uniq(letters) == letters
  end
end
