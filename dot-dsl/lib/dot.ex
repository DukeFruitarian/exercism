defmodule Dot do
  @types [:attrs, :nodes, :edges]
  defmacro graph(do: block) do
    Enum.reduce(@types, Dot.collect_terms(block), fn type, res ->
      elem(Map.get_and_update(res, type, fn t -> {t, Enum.sort(t)} end), 1)
    end)
    |> Macro.escape()
  end

  def collect_terms(nil), do: %Graph{}
  def collect_terms({:__block__, _, terms}), do: Enum.reduce(terms, %Graph{}, &parse_term/2)
  def collect_terms(term), do: parse_term(term, %Graph{})

  def parse_term({:graph, _, [[]]}, graph), do: graph

  def parse_term({:graph, _, [keyword_list]}, graph = %{attrs: attrs}) do
    %{graph | attrs: attrs ++ keyword_list}
  end

  def parse_term({:--, _, [{a, _, nil}, {b, _, [opts]}]}, graph = %{edges: edges}) do
    %{graph | edges: [{a, b, opts} | edges]}
  end

  def parse_term({:--, _, [{a, _, nil}, {b, _, nil}]}, graph = %{edges: edges}) do
    %{graph | edges: [{a, b, []} | edges]}
  end

  def parse_term({term, _, [[opt = {_, _}]]}, graph = %{nodes: nodes}) do
    %{graph | nodes: [{term, [opt]} | nodes]}
  end

  def parse_term({term, _, opt}, graph = %{nodes: nodes}) when opt in [[[]], nil] do
    %{graph | nodes: [{term, []} | nodes]}
  end

  def parse_term(_, _graph), do: raise(ArgumentError)
end
