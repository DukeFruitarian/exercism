defmodule Grep do
  @spec grep(String.t(), [String.t()], [String.t()]) :: String.t()
  def grep(pattern, flags, files) do
    result = Enum.reduce(files, %{}, &do_grep(&1, &2, pattern, List.delete(flags, "-l")))

    if "-l" in flags do
      for {key, values} <- result,
          !Enum.empty?(values) do
        key <> "\n"
      end
    else
      case map_size(result) do
        0 ->
          []

        1 ->
          result
          |> Enum.map(&elem(&1, 1))

        _ ->
          result
          |> Enum.map(fn {filename, matched_lines} ->
            Enum.map(matched_lines, fn matched_line -> filename <> ":" <> matched_line end)
          end)
      end
    end
    |> List.flatten()
    |> Enum.join()
  end

  defp do_grep(file_name, result_map, pattern, flags) do
    stream =
      File.stream!(file_name)
      |> Stream.with_index()

    lines_with_index =
      if "-v" in flags do
        Enum.reject(stream, &matched?(&1, pattern, flags -- ["-v", "-n"]))
      else
        Enum.filter(stream, &matched?(&1, pattern, flags -- ["-v", "-n"]))
      end

    lines =
      if "-n" in flags do
        Enum.map(lines_with_index, fn {line, idx} -> "#{idx + 1}:#{line}" end)
      else
        Enum.map(lines_with_index, &elem(&1, 0))
      end

    Map.put(result_map, file_name, lines)
  end

  defp matched?({line, _idx}, pattern, flags) do
    case Enum.sort(flags) do
      ["-i", "-x"] -> ~r/\A#{pattern}\n\z/i
      ["-i"] -> ~r/#{pattern}/i
      ["-x"] -> ~r/\A#{pattern}\n\z/
      [] -> ~r/#{pattern}/
    end
    |> Regex.match?(line)
  end
end
