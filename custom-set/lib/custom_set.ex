defmodule CustomSet do
  @opaque t :: %__MODULE__{map: map}
  defstruct [:map]

  @spec new(Enum.t()) :: t

  def new(enumerable) do
    if Enum.empty?(enumerable) do
      %CustomSet{}
    else
      map =
        for key <- enumerable, into: %{} do
          if is_tuple(key), do: key, else: {key, key}
        end

      %CustomSet{map: map}
    end
  end

  @spec empty?(t) :: boolean
  def empty?(%CustomSet{map: map}) do
    !map || Enum.empty?(map)
  end

  @spec contains?(t, any) :: boolean
  def contains?(%CustomSet{map: map}, element) do
    !is_nil(map) && Map.has_key?(map, element)
  end

  @spec subset?(t, t) :: boolean
  def subset?(%CustomSet{map: map1}, %CustomSet{map: map2}) do
    !map1 || (!is_nil(map2) && Enum.all?(map1, fn {key, _} -> Map.has_key?(map2, key) end))
  end

  @spec disjoint?(t, t) :: boolean
  def disjoint?(%CustomSet{map: map1}, %CustomSet{map: map2}) do
    !map1 || !map2 || !Enum.any?(map1, fn {key, _} -> Map.has_key?(map2, key) end)
  end

  @spec equal?(t, t) :: boolean
  def equal?(%CustomSet{map: map1}, %CustomSet{map: map2}) do
    map1 == map2
  end

  @spec add(t, any) :: t
  def add(%CustomSet{map: map} = custom_set, element) do
    %{custom_set | map: Map.put(map || %{}, element, element)}
  end

  @spec intersection(t, t) :: t
  def intersection(%CustomSet{map: map1}, %CustomSet{map: map2})
      when is_nil(map1) or is_nil(map2),
      do: %CustomSet{}

  def intersection(%CustomSet{map: map1}, %CustomSet{map: map2}) do
    Enum.filter(map1, fn {key, _} -> Map.has_key?(map2, key) end)
    |> new
  end

  @spec difference(t, t) :: t
  def difference(%CustomSet{map: nil}, _custom_set), do: %CustomSet{}
  def difference(custom_set, %CustomSet{map: nil}), do: custom_set

  def difference(%CustomSet{map: map1}, %CustomSet{map: map2}) do
    Enum.reject(map1, fn {key, _} -> Map.has_key?(map2, key) end)
    |> new
  end

  @spec union(t, t) :: t
  def union(%CustomSet{map: nil}, custom_set), do: custom_set
  def union(custom_set, %CustomSet{map: nil}), do: custom_set

  def union(%CustomSet{map: map1}, %CustomSet{map: map2}) do
    for(el <- map1, into: map2, do: el)
    |> new
  end
end
