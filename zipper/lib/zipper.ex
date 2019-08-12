defmodule Zipper do
  @doc """
  Get a zipper focused on the root node.
  """
  defstruct [:root, path: []]
  @spec from_tree(BinTree.t()) :: Zipper.t()
  def from_tree(bin_tree) do
    %Zipper{root: bin_tree}
  end

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree(zipper) do
    zipper.root
  end

  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any
  def value(zipper) do
    current_node(zipper).value
  end

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t() | nil
  def left(%{path: path} = zipper) do
    new_zipper = %{zipper | path: [:left | path]}
    current_node(new_zipper) && new_zipper
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t() | nil
  def right(%{path: path} = zipper) do
    new_zipper = %{zipper | path: [:right | path]}
    current_node(new_zipper) && new_zipper
  end

  defp current_node(%Zipper{root: root, path: path}) do
    Enum.reverse(path)
    |> Enum.reduce(root, &Map.get(&2, &1))
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Zipper.t()) :: Zipper.t() | nil
  def up(%{path: [_path_head | path_tail]} = zipper) do
    %{zipper | path: path_tail}
  end

  def up(_zipper), do: nil

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any) :: Zipper.t()

  def set_value(zipper, value) do
    %{zipper | root: set_node(zipper.root, current_path(zipper), :value, value)}
  end

  defp set_node(node, [direction | path_tail], property, value) do
    Map.put(
      node,
      direction,
      set_node(Map.get(node, direction), path_tail, property, value)
    )
  end

  defp set_node(node, [], property, value) do
    Map.put(node, property, value)
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left(zipper, left) do
    %{zipper | root: set_node(zipper.root, current_path(zipper), :left, left)}
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right(zipper, right) do
    %{zipper | root: set_node(zipper.root, current_path(zipper), :right, right)}
  end

  defp current_path(%{path: path}) do
    Enum.reverse(path)
  end
end
