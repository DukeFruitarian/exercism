defmodule Say do
  @doc """
  Translate a positive integer into English.
  """
  @exponents %{
    0 => "",
    1 => " thousand",
    2 => " million",
    3 => " billion"
  }

  @units %{
    1 => "one",
    2 => "two",
    3 => "three",
    4 => "four",
    5 => "five",
    6 => "six",
    7 => "seven",
    8 => "eight",
    9 => "nine",
    10 => "ten",
    11 => "eleven",
    12 => "twelve",
    13 => "thirteen",
    14 => "fourteen",
    15 => "fifteen",
    16 => "sixteen",
    17 => "seventeem",
    18 => "eighteen",
    19 => "nineteen"
  }

  @dozens %{
    2 => "twenty",
    3 => "thirty",
    4 => "forty",
    5 => "fifty",
    6 => "sixty",
    7 => "seventy",
    8 => "eighty",
    9 => "ninety"
  }

  @spec in_english(integer) :: {atom, String.t()}
  def in_english(number) when number < 0 or number >= 1_000_000_000_000 do
    {:error, "number is out of range"}
  end

  def in_english(0), do: {:ok, "zero"}

  def in_english(number) do
    {:ok, transform(number)}
  end

  defp transform(number) do
    Integer.digits(number)
    |> Enum.reverse()
    |> Stream.chunk_every(3, 3, [0, 0])
    |> Stream.with_index()
    |> Stream.map(fn {digits, idx} -> {under_thousand_in_english(Enum.reverse(digits)), idx} end)
    |> Stream.map(&add_exponents/1)
    |> Enum.reverse()
    |> Stream.filter(&(&1 != ""))
    |> Enum.join(" ")
  end

  defp under_thousand_in_english([0, 0, 0]), do: ""
  defp under_thousand_in_english([0, 0, unit]), do: @units[unit]
  defp under_thousand_in_english([0, 1, unit]), do: @units[10 + unit]
  defp under_thousand_in_english([0, dozen, 0]), do: @dozens[dozen]
  defp under_thousand_in_english([0, dozen, unit]), do: @dozens[dozen] <> "-" <> @units[unit]

  defp under_thousand_in_english([hundred, 0, 0]) do
    under_thousand_in_english([0, 0, hundred]) <> " hundred"
  end

  defp under_thousand_in_english([hundred, dozen, unit]) do
    under_thousand_in_english([0, 0, hundred]) <>
      " hundred " <> under_thousand_in_english([0, dozen, unit])
  end

  def add_exponents({"", _}), do: ""
  def add_exponents({stringified_thousand, index}), do: stringified_thousand <> @exponents[index]
end
