defmodule BeerSong do
  @doc """
  Get a single verse of the beer song
  """
  @spec verse(integer) :: String.t()
  def verse(0) do
    """
    No more bottles of beer on the wall, no more bottles of beer.
    Go to the store and buy some more, 99 bottles of beer on the wall.
    """
  end

  def verse(n) do
    """
    #{bottles(n)} of beer on the wall, #{bottles(n)} of beer.
    #{take_part(n)}, #{bottles(n - 1)} of beer on the wall.
    """
  end

  @doc """
  Get the entire beer song for a given range of numbers of bottles.
  """
  @spec lyrics(Range.t()) :: String.t()
  def lyrics(range \\ 99..0) do
    Enum.map(range, &verse/1)
    |> Enum.join("\n")
  end

  defp bottles(0), do: "no more bottles"
  defp bottles(1), do: "1 bottle"
  defp bottles(n), do: "#{n} bottles"

  defp take_part(1), do: "Take it down and pass it around"
  defp take_part(n), do: "Take one down and pass it around"
end
