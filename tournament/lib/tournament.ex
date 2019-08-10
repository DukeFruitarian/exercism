defmodule Tournament do
  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """

  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    Stream.map(input, &String.split(&1, ";"))
    |> Enum.map(&normalize_input/1)
    |> List.flatten()
    |> Enum.reduce(%{}, &calculate_results/2)
    |> Enum.sort_by(&team_sort_weight/1, &>=/2)
    |> Stream.map(&format_team_result/1)
    |> compose_output
  end

  defp normalize_input([team1 | [team2 | ["win"]]]) do
    [{team1, :win}, {team2, :loss}]
  end

  defp normalize_input([team1 | [team2 | ["loss"]]]) do
    [{team1, :loss}, {team2, :win}]
  end

  defp normalize_input([team1 | [team2 | ["draw"]]]) do
    [{team1, :draw}, {team2, :draw}]
  end

  defp normalize_input(_invalid_line), do: []

  defp calculate_results({team_name, :win}, acc) do
    case Map.get(acc, team_name) do
      %{mp: mp, w: w, d: d, l: l, p: p} ->
        %{acc | team_name => %{mp: mp + 1, w: w + 1, d: d, l: l, p: p + 3}}

      nil ->
        Map.put(acc, team_name, %{mp: 1, w: 1, d: 0, l: 0, p: 3})
    end
  end

  defp calculate_results({team_name, :loss}, acc) do
    case Map.get(acc, team_name) do
      %{mp: mp, w: w, d: d, l: l, p: p} ->
        %{acc | team_name => %{mp: mp + 1, w: w, d: d, l: l + 1, p: p}}

      nil ->
        Map.put(acc, team_name, %{mp: 1, w: 0, d: 0, l: 1, p: 0})
    end
  end

  defp calculate_results({team_name, :draw}, acc) do
    case Map.get(acc, team_name) do
      %{mp: mp, w: w, d: d, l: l, p: p} ->
        %{acc | team_name => %{mp: mp + 1, w: w, d: d + 1, l: l, p: p + 1}}

      nil ->
        Map.put(acc, team_name, %{mp: 1, w: 0, d: 1, l: 0, p: 1})
    end
  end

  defp team_sort_weight({team, %{p: p}}) do
    p * 100 + ?Z - List.first(String.to_charlist(team))
  end

  defp format_team_result({team, %{mp: mp, w: w, d: d, l: l, p: p}}) do
    String.pad_trailing(team, 30) <>
      " | " <>
      String.pad_leading(to_string(mp), 2) <>
      " | " <>
      String.pad_leading(to_string(w), 2) <>
      " | " <>
      String.pad_leading(to_string(d), 2) <>
      " | " <>
      String.pad_leading(to_string(l), 2) <>
      " | " <>
      String.pad_leading(to_string(p), 2)
  end

  defp compose_output(teams_results) do
    "Team                           | MP |  W |  D |  L |  P\n" <>
      Enum.join(teams_results, "\n")
  end
end
