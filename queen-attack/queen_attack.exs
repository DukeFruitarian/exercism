defmodule Queens do
  @type t :: %Queens{ white: {integer, integer}, black: {integer, integer} }
  defstruct white: nil, black: nil

  def new, do: %Queens{white: {0, 3}, black: {7, 3}}
  def new(pos, pos), do: raise ArgumentError
  def new(white, black), do: %Queens{black: black, white: white}

  @spec to_string(Queens.t()) :: String.t()
  def to_string(%Queens{} = queens) do
    Enum.reduce(0..7, "", fn vertical, top_acc ->
      line = Enum.reduce(0..7, "", fn horisontal, bot_acc ->
        bot_acc <> get_pic(queens, vertical, horisontal)
      end)

      top_acc <> String.rstrip(line) <> "\n"
    end)
    |> String.rstrip
  end

  defp get_pic(%Queens{black: {v, h}}, v, h), do: "B "
  defp get_pic(%Queens{white: {v, h}}, v, h), do: "W "
  defp get_pic(_, _, _), do: "_ "

  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(%Queens{white: {v, _}, black: {v, _}}), do: true
  def can_attack?(%Queens{white: {_, h}, black: {_, h}}), do: true
  def can_attack?(%Queens{white: {wv, wh}, black: {bv, bh}}) when wv - wh == bv - bh, do: true
  def can_attack?(%Queens{white: {wv, wh}, black: {bv, bh}}) when wv + wh == bv + bh, do: true
  def can_attack?(%Queens{}), do: false
end