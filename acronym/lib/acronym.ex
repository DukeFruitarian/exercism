defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    Regex.scan(~r/(?:(?:\A|[^[:alpha:]])([[:alpha:]])|[a-z]([A-Z]))/, string,
      capture: :all_but_first
    )
    |> to_string()
    |> String.upcase()
  end
end
