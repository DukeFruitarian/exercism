defmodule RobotSimulator do
  use GenServer

  defstruct direction: :north, position: {0, 0}
  @directions [:north, :east, :south, :west]

  @turn_left_directions %{
    north: :west,
    west: :south,
    south: :east,
    east: :north
  }

  @turn_right_directions %{
    south: :west,
    west: :north,
    north: :east,
    east: :south
  }

  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create, do: create(:north, {0, 0})

  def create(direction, _position) when direction not in @directions,
    do: {:error, "invalid direction"}

  def create(direction, {x, y} = position)
      when is_integer(x) and is_integer(y) do
    {:ok, pid} = GenServer.start_link(__MODULE__, {direction, position})

    pid
  end

  def create(_direction, _position), do: {:error, "invalid position"}

  def simulate(robot, instructions) do
    case String.match?(instructions, ~r/[^LAR]/) do
      false ->
        GenServer.cast(robot, {:simulate, instructions})
        robot

      _ ->
        {:error, "invalid instruction"}
    end
  end

  def position(robot), do: GenServer.call(robot, :get_position)
  def direction(robot), do: GenServer.call(robot, :get_direction)

  defp do_directives(state, directives) do
    String.graphemes(directives)
    |> Enum.reduce(state, &do_directive/2)
  end

  defp do_directive("L", %{direction: direction} = state),
    do: %{state | direction: @turn_left_directions[direction]}

  defp do_directive("R", %{direction: direction} = state),
    do: %{state | direction: @turn_right_directions[direction]}

  defp do_directive("A", %{direction: :north, position: {x, y}} = state) do
    %{state | position: {x, y + 1}}
  end

  defp do_directive("A", %{direction: :east, position: {x, y}} = state) do
    %{state | position: {x + 1, y}}
  end

  defp do_directive("A", %{direction: :south, position: {x, y}} = state) do
    %{state | position: {x, y - 1}}
  end

  defp do_directive("A", %{direction: :west, position: {x, y}} = state) do
    %{state | position: {x - 1, y}}
  end

  # server-side functions
  def init({direction, position}) do
    {:ok, %RobotSimulator{direction: direction, position: position}}
  end

  def handle_call(:get_position, _, state), do: {:reply, state.position, state}
  def handle_call(:get_direction, _, state), do: {:reply, state.direction, state}

  def handle_cast({:simulate, directives}, state) do
    {:noreply, do_directives(state, directives)}
  end
end
