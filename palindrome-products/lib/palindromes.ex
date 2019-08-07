defmodule Palindromes do
  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max_factor, min_factor \\ 1) do
    # for x <- min_factor..max_factor,
    #     y <- min_factor..max_factor,
    #     x <= y,
    #     product_palindrome?(to_string(x * y)) do
    #   {x * y, [[x, y]]}
    # end
    # # |> IO.inspect()
    # |> Enum.reduce(%{}, fn {palindrome, [multipliers]}, palindromes_map ->
    #   Map.update(palindromes_map, palindrome, [multipliers], fn matched_multipliers ->
    #     # IO.inspect({multipliers, matched_multipliers})
    #     [multipliers | matched_multipliers]
    #   end)
    # end)

    Enum.reduce(min_factor..max_factor, %{}, fn top_factor, palindroms_map ->
      current_palindromes =
        min_factor..top_factor
        |> Stream.filter(&product_palindrome?(Integer.to_string(&1 * top_factor)))
        |> Enum.reduce(
          palindroms_map,
          fn bottom_factor, acc ->
            Map.update(
              acc,
              bottom_factor * top_factor,
              [[bottom_factor, top_factor]],
              fn multipliers ->
                [[bottom_factor, top_factor] | multipliers]
              end
            )
          end
        )
    end)
  end

  # &[multipliers | &1]
  defp product_palindrome?(number) when byte_size(number) == 1, do: true

  defp product_palindrome?(<<a::binary-1, a::binary-1>> = number) when byte_size(number) == 2,
    do: true

  defp product_palindrome?(number) when byte_size(number) == 2, do: false

  defp product_palindrome?(<<a::binary-1, b::binary-1, b::binary-1, a::binary-1>> = number)
       when byte_size(number) == 4,
       do: true

  defp product_palindrome?(number) when byte_size(number) == 4, do: false

  defp product_palindrome?(<<a::binary-1, b::binary-1, a::binary-1>> = number)
       when byte_size(number) == 3,
       do: true

  defp product_palindrome?(number) when byte_size(number) == 3, do: false

  defp product_palindrome?(
         <<a::binary-1, b::binary-1, c::binary-1, b::binary-1, a::binary-1>> = number
       )
       when byte_size(number) == 5,
       do: true

  defp product_palindrome?(number) when byte_size(number) == 5, do: false

  defp product_palindrome?(
         <<a::binary-1, b::binary-1, c::binary-1, c::binary-1, b::binary-1, a::binary-1>> = number
       )
       when byte_size(number) == 6,
       do: true

  defp product_palindrome?(number) when byte_size(number) == 6, do: false
end
