defmodule TwelveDays do
  @doc """
  Given a `number`, return the song's verse for that specific day, including
  all gifts for previous days in the same line.
  """
  @parts %{
    1 => %{
      title: "first",
      sentence: "a Partridge in a Pear Tree"
    },
    2 => %{
      title: "second",
      sentence: "two Turtle Doves"
    },
    3 => %{
      title: "third",
      sentence: "three French Hens"
    },
    4 => %{
      title: "fourth",
      sentence: "four Calling Birds"
    },
    5 => %{
      title: "fifth",
      sentence: "five Gold Rings"
    },
    6 => %{
      title: "sixth",
      sentence: "six Geese-a-Laying"
    },
    7 => %{
      title: "seventh",
      sentence: "seven Swans-a-Swimming"
    },
    8 => %{
      title: "eighth",
      sentence: "eight Maids-a-Milking"
    },
    9 => %{
      title: "ninth",
      sentence: "nine Ladies Dancing"
    },
    10 => %{
      title: "tenth",
      sentence: "ten Lords-a-Leaping"
    },
    11 => %{
      title: "eleventh",
      sentence: "eleven Pipers Piping"
    },
    12 => %{
      title: "twelfth",
      sentence: "twelve Drummers Drumming"
    }
  }
  @spec verse(number :: integer) :: String.t()
  def verse(number) do
    "On the #{@parts[number][:title]} day of Christmas my true love gave to me: #{
      gave_message(number)
    }."
  end

  defp gave_message(1), do: @parts[1][:sentence]
  defp gave_message(2), do: "#{@parts[2][:sentence]}, and #{gave_message(1)}"
  defp gave_message(number), do: "#{@parts[number][:sentence]}, #{gave_message(number - 1)}"

  @doc """
  Given a `starting_verse` and an `ending_verse`, return the verses for each
  included day, one per line.
  """
  @spec verses(starting_verse :: integer, ending_verse :: integer) :: String.t()
  def verses(starting_verse, ending_verse) do
    Stream.map(starting_verse..ending_verse, &verse/1)
    |> Enum.join("\n")
  end

  @doc """
  Sing all 12 verses, in order, one verse per line.
  """
  @spec sing() :: String.t()
  def sing do
    verses(1, 12)
  end
end
