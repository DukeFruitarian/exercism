defmodule School do
  @spec add(map, String.t, integer) :: map
  def add(db, name, grade), do: Map.update(db, grade, [name], &[name | &1])

  @spec grade(map, integer) :: [String.t]
  def grade(db, grade), do: Map.get(db, grade, [])

  @spec sort(map) :: [{integer, [String.t]}]
  def sort(db) do
    Stream.map(db, fn {key, list} -> {key, Enum.sort(list)} end)
    |> Enum.sort_by(&elem(&1, 0))
  end
end