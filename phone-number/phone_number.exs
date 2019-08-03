defmodule Phone do
  @spec number(String.t) :: String.t
  def number(raw) do
    normalize_phone(raw)
  end

  @spec area_code(String.t) :: String.t
  def area_code(raw) do
    normalize_phone(raw)
    |> String.slice(0..2)
  end

  @spec pretty(String.t) :: String.t
  def pretty(raw) do
    normalize_phone(raw)
    |> String.replace(~r/\A(\d{3})(\d{3})(\d{4})\z/, "(\\1) \\2-\\3")
  end

  defp normalize_phone(raw) do
    phone = String.replace(raw, ~r/[^[:alnum:]]/, "")
    cond do
      Regex.match?(~r/[[:alpha:]]/, phone) ->
        "0000000000"
      String.length(phone) == 10 ->
        phone
      String.length(phone) == 11 && String.first(phone) == "1" ->
        String.slice(phone, 1..-1)
      true ->
        "0000000000"
    end
  end
end