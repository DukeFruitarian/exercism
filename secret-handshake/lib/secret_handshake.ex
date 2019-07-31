defmodule SecretHandshake do
  @actions {"wink", "double blink", "close your eyes", "jump"}
  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    Integer.digits(code, 2)
    |> Enum.reverse()
    |> Stream.with_index()
    |> Enum.reduce([], &fill_list/2)
    |> Enum.reverse()
  end

  defp fill_list({1, 4}, list) do
    Enum.reverse(list)
  end

  defp fill_list({1, idx}, list) when idx < 4 do
    [elem(@actions, idx) | list]
  end

  defp fill_list(_, list) do
    list
  end
end
