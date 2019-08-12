defmodule Garden do
  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """
  @default_names [
    :alice,
    :bob,
    :charlie,
    :david,
    :eve,
    :fred,
    :ginny,
    :harriet,
    :ileana,
    :joseph,
    :kincaid,
    :larry
  ]

  @plants %{
    "R" => :radishes,
    "C" => :clover,
    "G" => :grass,
    "V" => :violets
  }

  @spec info(String.t(), list) :: map
  def info(info_string, student_names \\ @default_names) do
    grouped_plants =
      String.split(info_string, "\n")
      |> Stream.map(&String.graphemes(&1))
      |> Enum.map(&Enum.chunk_every(&1, 2))
      |> List.zip()

    for {name, index} <- Enum.with_index(Enum.sort(student_names)), into: %{} do
      {name, translate(Enum.at(grouped_plants, index))}
    end
  end

  defp translate(nil), do: {}

  defp(translate({[first, second], [third, fourth]})) do
    {@plants[first], @plants[second], @plants[third], @plants[fourth]}
  end
end
