defmodule ProteinTranslation do
  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: {atom, list(String.t())}
  def of_rna(rna) do
    for(<<codon::binary-3 <- rna>>, do: of_codon(codon))
    |> translate([])
  end

  defp translate([{:error, "invalid codon"} | _], _), do: {:error, "invalid RNA"}
  defp translate([{:ok, "STOP"} | _], translated), do: {:ok, Enum.reverse(translated)}
  defp translate([{:ok, protein}], translated), do: {:ok, Enum.reverse([protein | translated])}
  defp translate([{:ok, protein} | rest], translated), do: translate(rest, [protein | translated])

  @spec of_codon(String.t()) :: {atom, String.t()}
  def of_codon(codon) when codon in ["UAA", "UAG", "UGA"], do: {:ok, "STOP"}
  def of_codon(codon) when codon in ["UAC", "UAU"], do: {:ok, "Tyrosine"}
  def of_codon(codon) when codon in ["UCG", "UCA", "UCC", "UCU"], do: {:ok, "Serine"}
  def of_codon(codon) when codon in ["UUC", "UUU"], do: {:ok, "Phenylalanine"}
  def of_codon(codon) when codon in ["UUG", "UUA"], do: {:ok, "Leucine"}
  def of_codon(codon) when codon in ["UGU", "UGC"], do: {:ok, "Cysteine"}
  def of_codon("AUG"), do: {:ok, "Methionine"}
  def of_codon("UGG"), do: {:ok, "Tryptophan"}
  def of_codon(_), do: {:error, "invalid codon"}
end
