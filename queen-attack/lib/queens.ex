defmodule Queens do
  @type t :: %Queens{black: {integer, integer}, white: {integer, integer}}
  defstruct black: nil, white: nil

  @doc """
  Creates a new set of Queens
  """
  @spec new() :: Queens.t()
  @spec new({integer, integer}, {integer, integer}) :: Queens.t()
  def new, do: new({0, 3}, {7, 3})

  def new(white, black) when white == black do
    raise ArgumentError
  end

  def new(white, black) do
    %Queens{white: white, black: black}
  end

  @doc """
  Gives a string representation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(queens) do
    Enum.map_join(0..7, "\n", fn x ->
      Enum.map_join(0..7, " ", &draw_block(queens, x, &1))
    end)
  end

  defp draw_block(%{white: {x, y}}, x, y), do: "W"
  defp draw_block(%{black: {x, y}}, x, y), do: "B"
  defp draw_block(_queens, _x, _y), do: "_"

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(%{white: {x1, _}, black: {x1, _}}), do: true
  def can_attack?(%{white: {_, y1}, black: {_, y1}}), do: true

  def can_attack?(%{white: {x1, y1}, black: {x2, y2}}) when y1 - x1 == y2 - x2,
    do: true

  def can_attack?(%{white: {y1, x1}, black: {y2, x2}}) when y1 + x1 == y2 + x2,
    do: true

  def can_attack?(_queens), do: false
end
