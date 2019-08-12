defmodule BinarySearchTree do
  @type bst_node :: %{data: any, left: bst_node | nil, right: bst_node | nil}
  defstruct [:data, left: nil, right: nil]

  @doc """
  Create a new Binary Search Tree with root's value as the given 'data'
  """
  @spec new(any) :: bst_node
  def new(data) do
    insert(nil, data)
  end

  @doc """
  Creates and inserts a node with its value as 'data' into the tree.
  """
  @spec insert(bst_node, any) :: bst_node
  def insert(nil, data), do: %BinarySearchTree{data: data}

  def insert(%{data: node_data} = tree, data) when node_data >= data do
    %{tree | left: insert(tree.left, data)}
  end

  def insert(tree, data), do: %{tree | right: insert(tree.right, data)}

  @doc """
  Traverses the Binary Search Tree in order and returns a list of each node's data.
  """
  @spec in_order(bst_node) :: [any]
  def in_order(tree) do
    listify([], tree)
    |> Enum.reverse()
  end

  defp listify(list, nil), do: list

  defp listify(list, tree) do
    [tree.data | listify(list, tree.left)]
    |> listify(tree.right)
  end
end
