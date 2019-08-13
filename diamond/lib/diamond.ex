defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t()

  def build_shape(letter) do
    do_build(letter) <> "\n"
  end

  def do_build(?A), do: "A"

  def do_build(letter) do
    Enum.concat(0..(letter - ?A), (letter - ?B)..0)
    |> Enum.map_join("\n", &generate_line(&1, letter - ?A))
  end

  defp generate_line(index, total) do
    spaces = String.duplicate(" ", total - index)
    spaces <> diamond_part(index) <> spaces
  end

  defp diamond_part(0), do: "A"

  defp diamond_part(index) do
    letter = ?A + index

    List.flatten([letter, Enum.map(1..(index * 2 - 1), fn _ -> ' ' end), letter])
    |> to_string()
  end
end
