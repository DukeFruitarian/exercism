defmodule Dominoes do
  @type domino :: {1..6, 1..6}

  defstruct([:a, :b, rest_dominoes: []])

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino] | []) :: boolean
  def chain?(dominoes) do
    !!built_chain?({nil, nil}, dominoes)
  end

  defp built_chain?({a, b}, []), do: a == b

  defp built_chain?({nil, nil}, dominoes) do
    dominoes
    |> Stream.with_index()
    |> Enum.find(fn
      {{a, a}, idx} ->
        IO.inspect({{a, a}, idx, List.delete_at(dominoes, idx)})
        built_chain?({a, a}, List.delete_at(dominoes, idx))

      {{a, b}, idx} ->
        rest = List.delete_at(dominoes, idx)
        built_chain?({a, b}, rest) || built_chain?({b, a}, rest)
    end)
  end

  defp built_chain?({a, b}, dominoes) do
    dominoes
    |> Stream.with_index()
    |> Enum.find(fn
      {{^b, c}, idx} ->
        built_chain?({a, c}, List.delete_at(dominoes, idx))

      {{c, ^b}, idx} ->
        built_chain?({a, c}, List.delete_at(dominoes, idx))

      {_dominoe, _idx} ->
        nil
    end)
  end
end
