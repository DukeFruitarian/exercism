defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t(), pos_integer) :: String.t()
  def encode(str, 1), do: str
  def encode("", _rails), do: ""

  def encode(str, rails) do
    result =
      Enum.concat(1..(rails - 1), rails..2)
      |> Stream.cycle()
      |> Enum.reduce_while({str, %{}}, &collect/2)

    1..rails
    |> Enum.map_join(&Map.get(result, &1))
  end

  defp collect(rail_number, {<<letter::binary-1>>, acc}) do
    {:halt, Map.update(acc, rail_number, letter, &(&1 <> letter))}
  end

  defp collect(rail_number, {<<letter::binary-1, rest::binary>>, acc}) do
    {:cont, {rest, Map.update(acc, rail_number, letter, &(&1 <> letter))}}
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  def decode(str, 1), do: str
  def decode("", _rails), do: ""

  @spec decode(String.t(), pos_integer) :: String.t()
  def decode(str, rails) do
    total_letters = String.length(str)

    lines_map =
      1..rails
      |> Enum.flat_map_reduce(str, fn rail_number, acc ->
        size = chunk_size(total_letters, rail_number, rails)
        <<line::binary-size(size), rest::binary>> = acc
        {[{rail_number, line}], rest}
      end)
      |> elem(0)
      |> Map.new()

    Enum.concat(1..(rails - 1), rails..2)
    |> Stream.cycle()
    |> Enum.reduce_while({"", lines_map}, &pinch_off/2)
  end

  defp pinch_off(number, {result, map}) do
    cond do
      Enum.all?(map, fn {_key, line} -> line == "" end) ->
        {:halt, result}

      true ->
        {:cont,
         Map.get_and_update(map, number, fn
           <<letter::binary-1, rest::binary>> -> {result <> letter, rest}
         end)}
    end
  end

  defp chunk_size(total_letters, rail_number, rails_quantity) do
    full_circles = div(total_letters, rails_quantity * 2 - 2)
    last_circle_letters = rem(total_letters, rails_quantity * 2 - 2)

    case rail_number do
      n when n in [1, rails_quantity] ->
        full_circles + if last_circle_letters >= n, do: 1, else: 0

      n ->
        full_circles * 2 +
          cond do
            2 * rails_quantity - n <= last_circle_letters -> 2
            last_circle_letters >= n -> 1
            true -> 0
          end
    end
  end
end
