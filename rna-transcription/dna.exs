defmodule DNA do
  @rna_map %{?G => ?C, ?C => ?G, ?T => ?A, ?A => ?U}

  @spec to_rna([char]) :: [char]
  def to_rna(dna), do: Enum.map(dna, &@rna_map[&1])
end