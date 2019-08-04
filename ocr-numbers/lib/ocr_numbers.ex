defmodule OcrNumbers do
  @doc """
  Given a 3 x 4 grid of pipes, underscores, and spaces, determine which number is represented, or
  whether it is garbled.
  """

  @spec convert([String.t()]) :: String.t()
  def convert(input) when rem(length(input), 4) != 0, do: {:error, 'invalid line count'}
  def convert([h | _]) when rem(byte_size(h), 3) != 0, do: {:error, 'invalid column count'}

  def convert(input) do
    {:ok,
     Enum.chunk_every(input, 4, 4)
     |> Enum.map(fn line ->
       Enum.map(line, fn string ->
         String.graphemes(string)
         |> Enum.chunk_every(3, 3)
       end)
       |> List.zip()
       |> Enum.map(&determine_digit/1)
       |> Enum.join()
     end)
     |> Enum.join(",")}
  end

  defp determine_digit({[" ", " ", " "], [" ", " ", "|"], [" ", " ", "|"], [" ", " ", " "]}),
    do: "1"

  defp determine_digit({[" ", "_", " "], [" ", "_", "|"], ["|", "_", " "], [" ", " ", " "]}),
    do: "2"

  defp determine_digit({[" ", "_", " "], [" ", "_", "|"], [" ", "_", "|"], [" ", " ", " "]}),
    do: "3"

  defp determine_digit({[" ", " ", " "], ["|", "_", "|"], [" ", " ", "|"], [" ", " ", " "]}),
    do: "4"

  defp determine_digit({[" ", "_", " "], ["|", "_", " "], [" ", "_", "|"], [" ", " ", " "]}),
    do: "5"

  defp determine_digit({[" ", "_", " "], ["|", "_", " "], ["|", "_", "|"], [" ", " ", " "]}),
    do: "6"

  defp determine_digit({[" ", "_", " "], [" ", " ", "|"], [" ", " ", "|"], [" ", " ", " "]}),
    do: "7"

  defp determine_digit({[" ", "_", " "], ["|", "_", "|"], ["|", "_", "|"], [" ", " ", " "]}),
    do: "8"

  defp determine_digit({[" ", "_", " "], ["|", "_", "|"], [" ", "_", "|"], [" ", " ", " "]}),
    do: "9"

  defp determine_digit({[" ", "_", " "], ["|", " ", "|"], ["|", "_", "|"], [" ", " ", " "]}),
    do: "0"

  defp determine_digit(_), do: "?"
end
