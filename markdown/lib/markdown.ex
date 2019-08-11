defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#text!\n* __Bold Item__\n* _Italic Item_")
    "<h1>text!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(raw) do
    process(raw <> "\n", [], "")
  end

  defp process("", [], parsed), do: parsed

  defp process(<<"#", raw::binary>>, [], parsed) do
    process(raw, [{"h", 1, ""}], parsed)
  end

  defp process(<<"#", raw::binary>>, [{"h", level, ""}], parsed) do
    process(raw, [{"h", level + 1, ""}], parsed)
  end

  defp process(<<" ", raw::binary>>, [{"h", level, ""}], parsed) do
    process(raw, [{"h", level, ""}], parsed)
  end

  defp process(<<"\n", raw::binary>>, [{"h", level, text} | stack_tail], parsed) do
    process(raw, stack_tail, "#{parsed}<h#{level}>#{text}</h#{level}>")
  end

  defp process(
         <<grapheme::binary-1, raw::binary>>,
         [{"h", level, text} | _stack_tail],
         parsed
       ) do
    process(raw, [{"h", level, text <> grapheme}], parsed)
  end

  defp process(<<"__", raw::binary>>, ["strong" | stack_tail], parsed) do
    process(raw, stack_tail, parsed <> "</strong>")
  end

  defp process(<<"__", raw::binary>>, [_ | _] = stack_tail, parsed) do
    process(raw, ["strong" | stack_tail], parsed <> "<strong>")
  end

  defp process(<<grapheme::binary-1, raw::binary>>, ["strong" | stack_tail], parsed) do
    process(raw, ["strong" | stack_tail], parsed <> grapheme)
  end

  defp process(<<"_", raw::binary>>, ["em" | stack_tail], parsed) do
    process(raw, stack_tail, parsed <> "</em>")
  end

  defp process(<<"_", raw::binary>>, [_ | _] = stack_tail, parsed) do
    process(raw, ["em" | stack_tail], parsed <> "<em>")
  end

  defp process(<<grapheme::binary-1, raw::binary>>, ["em" | stack_tail], parsed) do
    process(raw, ["em" | stack_tail], parsed <> grapheme)
  end

  defp process(<<"\n", "* ", raw::binary>>, ["li" | stack_tail], parsed) do
    process("* " <> raw, stack_tail, "#{parsed}</li>")
  end

  defp process(<<"\n", raw::binary>>, ["li" | ["ul" | stack_tail]], parsed) do
    process(raw, stack_tail, "#{parsed}</li></ul>")
  end

  defp process(<<"* ", raw::binary>>, ["ul" | _stack_tail] = stack, parsed) do
    process(raw, ["li" | stack], parsed <> "<li>")
  end

  defp process(<<"* ", raw::binary>>, stack, parsed) do
    process(raw, ["li" | ["ul" | stack]], parsed <> "<ul><li>")
  end

  defp process(<<grapheme::binary-1, raw::binary>>, ["li" | _stack_tail] = stack, parsed) do
    process(raw, stack, parsed <> grapheme)
  end

  defp process(<<"\n", raw::binary>>, ["p" | stack_tail], parsed) do
    process(raw, stack_tail, "#{parsed}</p>")
  end

  defp process(<<grapheme::binary-1, raw::binary>>, ["p" | _stack_tail], parsed) do
    process(raw, ["p"], parsed <> grapheme)
  end

  defp process(raw, [], parsed) do
    process(raw, ["p"], parsed <> "<p>")
  end
end
