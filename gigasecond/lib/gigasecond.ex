defmodule Gigasecond do
  @doc """
  Calculate a date one billion seconds after an input date.
  """
  @spec from({{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}) ::
          :calendar.datetime()

  def from({initial_date, time}, secs \\ 1_000_000_000) do
    {days, result_time} =
      (secs + :calendar.time_to_seconds(time))
      |> :calendar.seconds_to_daystime()

    result_date = days_past_date(initial_date, days)

    {result_date, result_time}
  end

  defp days_past_date(initial_date, days) do
    (:calendar.date_to_gregorian_days(initial_date) + days)
    |> :calendar.gregorian_days_to_date()
  end
end
