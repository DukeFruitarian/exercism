defmodule BracketPush do
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str) do
    do_check(str, [])
  end

  defp do_check("", []), do: true
  defp do_check("", _), do: false
  defp do_check(<<?{, rest::binary>>, stack), do: do_check(rest, ["{" | stack])
  defp do_check(<<?}, rest::binary>>, ["{" | stack]), do: do_check(rest, stack)
  defp do_check(<<?}, _::binary>>, _), do: false
  defp do_check(<<?[, rest::binary>>, stack), do: do_check(rest, ["[" | stack])
  defp do_check(<<?], rest::binary>>, ["[" | stack]), do: do_check(rest, stack)
  defp do_check(<<?], _::binary>>, _), do: false
  defp do_check(<<?(, rest::binary>>, stack), do: do_check(rest, ["(" | stack])
  defp do_check(<<?), rest::binary>>, ["(" | stack]), do: do_check(rest, stack)
  defp do_check(<<?), _::binary>>, _), do: false
  defp do_check(<<_::binary-1, rest::binary>>, stack), do: do_check(rest, stack)
end
