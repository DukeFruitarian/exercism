defmodule Bowling do
  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """
  defstruct passed_turns: [], current_turn: %{turn_number: 1, turn_hits: []}

  @spec start() :: any
  def start do
    %Bowling{}
  end

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """

  @spec roll(any, integer) :: any | String.t()
  def roll(%{current_turn: nil}, _roll), do: {:error, "Cannot roll after game is over"}
  def roll(_game, roll) when roll < 0, do: {:error, "Negative roll is invalid"}

  def roll(
        %{current_turn: %{turn_number: turn_number, turn_hits: turn_hits} = current_turn} = game,
        roll
      ) do
    multiplier = hit_multiplier_for(turn_number, turn_hits, game.passed_turns)

    case add_hit(game, {roll, multiplier}) do
      {:ok, :turn_continue, new_turn_hits} ->
        %{game | current_turn: %{current_turn | turn_hits: new_turn_hits}}

      {:ok, :turn_finished, new_turn_hits} ->
        add_turn(game, new_turn_hits)

      error ->
        error
    end
  end

  defp hit_multiplier_for(turn_number, [], [[{x, _}, {y, _}] | _later_turns]) when x + y == 10 do
    case turn_number do
      11 -> 1
      _ -> 2
    end
  end

  defp hit_multiplier_for(turn_number, [], [[{10, _}] | [[{10, _}] | _later_turns]]) do
    case turn_number do
      11 -> 2
      12 -> 1
      _ -> 3
    end
  end

  defp hit_multiplier_for(turn_number, _turn_hits, [[{10, _}] | _later_turns]) do
    case turn_number do
      11 -> 1
      _ -> 2
    end
  end

  defp hit_multiplier_for(_turn_number, _turn_hits, _passed_turns), do: 1

  def add_hit(_game, {roll, _}) when roll > 10 do
    {:error, "Pin count exceeds pins on the lane"}
  end

  def add_hit(%{current_turn: %{turn_hits: [{x, _}]}}, {roll, _}) when roll + x > 10 do
    {:error, "Pin count exceeds pins on the lane"}
  end

  def add_hit(%{current_turn: %{turn_hits: []}}, {10, _multiplier} = hit) do
    {:ok, :turn_finished, [hit]}
  end

  def add_hit(
        %{
          passed_turns: [tenth_hit | _previous_hits],
          current_turn: %{turn_number: 11, turn_hits: []}
        },
        hit
      ) do
    case tenth_hit do
      [{10, _}] -> {:ok, :turn_continue, [hit]}
      _ -> {:ok, :turn_finished, [hit]}
    end
  end

  def add_hit(%{current_turn: %{turn_number: 12}}, hit) do
    {:ok, :turn_finished, [hit]}
  end

  def add_hit(%{current_turn: %{turn_hits: []}}, hit) do
    {:ok, :turn_continue, [hit]}
  end

  def add_hit(%{current_turn: %{turn_hits: turn_hits}}, hit) do
    {:ok, :turn_finished, [hit | turn_hits]}
  end

  def add_turn(
        %{
          passed_turns: past_turns,
          current_turn: %{turn_number: 10}
        } = game,
        [{10, _multiplier}] = new_turn_hits
      ) do
    %{
      game
      | passed_turns: [new_turn_hits | past_turns],
        current_turn: %{turn_number: 11, turn_hits: []}
    }
  end

  def add_turn(
        %{
          passed_turns: past_turns,
          current_turn: %{turn_number: 10}
        } = game,
        [{x, _}, {y, _}] = new_turn_hits
      )
      when x + y == 10 do
    %{
      game
      | passed_turns: [new_turn_hits | past_turns],
        current_turn: %{turn_number: 11, turn_hits: []}
    }
  end

  def add_turn(
        %{
          passed_turns: [[{10, _}] | _previous_hits] = past_turns,
          current_turn: %{turn_number: 11}
        } = game,
        [{10, _}] = new_turn_hits
      ) do
    %{
      game
      | passed_turns: [new_turn_hits | past_turns],
        current_turn: %{turn_number: 12, turn_hits: []}
    }
  end

  def add_turn(
        %{
          passed_turns: past_turns,
          current_turn: %{turn_number: 11}
        } = game,
        [{10, _}] = new_turn_hits
      ) do
    %{
      game
      | passed_turns: [new_turn_hits | past_turns],
        current_turn: nil
    }
  end

  def add_turn(
        %{
          passed_turns: past_turns,
          current_turn: %{turn_number: turn_number}
        } = game,
        new_turn_hits
      )
      when turn_number in [10, 11, 12] do
    %{
      game
      | passed_turns: [new_turn_hits | past_turns],
        current_turn: nil
    }
  end

  def add_turn(
        %{
          passed_turns: past_turns,
          current_turn: %{turn_number: turn_number}
        } = game,
        new_turn_hits
      ) do
    %{
      game
      | passed_turns: [new_turn_hits | past_turns],
        current_turn: %{turn_number: turn_number + 1, turn_hits: []}
    }
  end

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful message.
  """

  @spec score(any) :: integer | String.t()
  def score(%{passed_turns: passed_turns, current_turn: nil} = game) do
    Enum.reduce(passed_turns, 0, fn
      [{x, mx}, {y, my}], acc ->
        x * mx + y * my + acc

      [{x, mx}], acc ->
        x * mx + acc
    end)
  end

  def score(game) do
    {:error, "Score cannot be taken until the end of the game"}
  end
end
