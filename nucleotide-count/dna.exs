defmodule DNA do
  @nucleotides [?A, ?C, ?G, ?T]

  @spec count([char], char) :: non_neg_integer
  def count(strand, nucleotide) when nucleotide in @nucleotides do
    histogram(strand)[nucleotide]
  end

  def count(_strand, _nucleotide) do
    raise ArgumentError
  end

  @spec histogram([char]) :: map
  def histogram(strand) do
    initial_histogram = for nuc <- @nucleotides, into: %{} do
      {nuc, 0}
    end

    Enum.reduce(strand, initial_histogram, fn (nucleotide, acc) ->
      if Enum.member?(@nucleotides, nucleotide) do
        %{acc | nucleotide => acc[nucleotide] + 1}
      else
        raise ArgumentError
      end
    end)
  end
end