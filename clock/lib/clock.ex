defmodule Clock do
  defstruct hour: 0, minute: 0

  @doc """
  Returns a clock that can be represented as a string:

      iex> Clock.new(8, 9) |> to_string
      "08:09"
  """
  # defstruct :hours, :minutes
  @spec new(integer, integer) :: Clock
  def new(hour, minute) when minute < 0, do: new(hour + div(minute, 60) - 1, rem(minute, 60) + 60)
  def new(hour, minute) when hour < 0, do: new(rem(hour, 24) + 24, minute)
  def new(hour, minute) when minute >= 60, do: new(hour + div(minute, 60), rem(minute, 60))
  def new(hour, minute) when hour >= 24, do: new(rem(hour, 24), minute)
  def new(hour, minute), do: %Clock{hour: hour, minute: minute}

  @doc """
  Adds two clock times:

      iex> Clock.new(10, 0) |> Clock.add(3) |> to_string
      "10:03"
  """
  @spec add(Clock, integer) :: Clock
  def add(%Clock{hour: hour, minute: minute}, add_minute) do
    new(hour, minute + add_minute)
  end
end

defimpl String.Chars, for: Clock do
  def to_string(%Clock{hour: hour, minute: minute}) do
    hour = String.pad_leading(Integer.to_string(hour), 2, "0")
    minute = String.pad_leading(Integer.to_string(minute), 2, "0")

    "#{hour}:#{minute}"
  end
end
