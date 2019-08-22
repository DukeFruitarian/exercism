defmodule CryptoSquare do
  @doc """
  Encode string square methods
  ## Examples

    iex> CryptoSquare.encode("abcd")
    "ac bd"
  """
  @spec encode(String.t()) :: String.t()

  def encode(""), do: ""

  def encode(str) do
    normalized = normalize(str)
    matrix_size = get_matrix_size(normalized)

    String.codepoints(normalized)
    |> Enum.chunk_every(matrix_size, matrix_size, Stream.cycle([" "]))
    |> List.zip()
    |> Stream.map(fn tuple -> Tuple.to_list(tuple) |> Enum.join() end)
    |> Enum.join(" ")
  end

  defp normalize(str) do
    String.replace(str, ~r/[^\d\p{L}]/u, "")
    |> String.downcase()
  end

  defp get_matrix_size(string) do
    String.length(string)
    |> :math.sqrt()
    |> Float.ceil()
    |> trunc()
  end
end
