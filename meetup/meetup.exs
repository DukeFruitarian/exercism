defmodule Meetup do
  @weekday_map %{ monday: 1, tuesday: 2, wednesday: 3,
    thursday: 4, friday: 5, saturday: 6, sunday: 7
  }

  @previous_month_ending_weekdays %{
    2013 => {1, 4, 4, 7, 2, 5, 7, 3, 6, 1, 4, 6}
  }

  @max_day_for_schedule %{
    first: 7,
    second: 14,
    third: 21,
    fourth: 28,
    teenth: 19,
    last: %{
      1 => 31,
      2 => 28,
      3 => 31,
      4 => 30,
      5 => 31,
      6 => 30,
      7 => 31,
      8 => 31,
      9 => 30,
      10 => 31,
      11 => 30,
      12 => 31
    }
  }

  @type weekday ::
      :monday | :tuesday | :wednesday
    | :thursday | :friday | :saturday | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: :calendar.date
  def meetup(year, month, weekday, schedule) do
    max_day = max_day_for_schedule(month, schedule)

    day = @previous_months_ending_weekday[year]
    |> elem(month - 1 )
    |> determine_day(weekday, max_day)


    {year, month, day}
  end

  defp max_day_for_schedule(month, :last) do
    @max_day_for_schedule[:last][month]
  end
  defp max_day_for_schedule(_month, schedule) do
    @max_day_for_schedule[schedule]
  end

  defp determine_day(previous_month_ending_weekday, weekday, max_day) do
    @weekday_map[weekday] - previous_month_ending_weekday
    |> last_possible_day(max_day)
  end

  defp last_possible_day(day, max_day) when day + 7 > max_day,  do: day
  defp last_possible_day(day, max_day), do: last_possible_day(day + 7, max_day)
end