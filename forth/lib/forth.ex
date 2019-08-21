defmodule Forth do
  @opaque evaluator :: any
  defstruct stack: [], custom_operations: %{}
  @dividers_rule ~r/[\x{1680}\x00\x01\n\r\t ]/u
  @digits ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
  @def_word_regex ~r/: (?<word>[^ ]+) (?<body>.+) ;/u
  @invalid_regex ~r/: (?<word>[\d]+) (?<body>.+) ;/u
  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new() do
    %Forth{}
  end

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(ev, s) do
    if String.match?(s, @invalid_regex), do: raise(Forth.InvalidWord)
    new_custom_operations = get_custom_operations(ev.custom_operations, s)

    replace_custom_operations(s)
    |> String.split(@dividers_rule)
    |> Enum.reduce(%{ev | custom_operations: new_custom_operations}, &evaluate/2)
  end

  defp get_custom_operations(custom_operations, s) do
    Regex.scan(@def_word_regex, s)
    |> Enum.into(custom_operations, fn [_, word, body] -> {word, body} end)
  end

  defp replace_custom_operations(s) do
    Regex.replace(@def_word_regex, s, fn _, _, _ -> "" end)
  end

  defp evaluate("", ev), do: ev

  defp evaluate(term, ev) do
    cond do
      is_integer?(term) ->
        %{ev | stack: [String.to_integer(term) | ev.stack]}

      func = Map.get(ev.custom_operations, term) ->
        eval(ev, func)

      new_ev = run_operation(ev, String.downcase(term)) ->
        new_ev

      true ->
        raise Forth.UnknownWord
    end
  end

  def is_integer?(term) do
    String.graphemes(term)
    |> Enum.all?(&(&1 in @digits))
  end

  def run_operation(%{stack: [h1, h2 | t]} = ev, "-") do
    %{ev | stack: [h2 - h1 | t]}
  end

  def run_operation(%{stack: [h1, h2 | t]} = ev, "*") do
    %{ev | stack: [h2 * h1 | t]}
  end

  def run_operation(%{stack: [0, _h2 | _t]}, "/"), do: raise(Forth.DivisionByZero)

  def run_operation(%{stack: [h1, h2 | t]} = ev, "/") do
    %{ev | stack: [div(h2, h1) | t]}
  end

  def run_operation(%{stack: [h1, h2 | t]} = ev, "+") do
    %{ev | stack: [h2 + h1 | t]}
  end

  def run_operation(%{stack: []}, "dup"), do: raise(Forth.StackUnderflow)

  def run_operation(%{stack: [h | t]} = ev, "dup") do
    %{ev | stack: [h, h | t]}
  end

  def run_operation(%{stack: []}, "drop"), do: raise(Forth.StackUnderflow)

  def run_operation(%{stack: [_h | t]} = ev, "drop") do
    %{ev | stack: t}
  end

  def run_operation(%{stack: []}, "swap"), do: raise(Forth.StackUnderflow)
  def run_operation(%{stack: [_]}, "swap"), do: raise(Forth.StackUnderflow)

  def run_operation(%{stack: [h1, h2 | t]} = ev, "swap") do
    %{ev | stack: [h2, h1 | t]}
  end

  def run_operation(%{stack: []}, "over"), do: raise(Forth.StackUnderflow)
  def run_operation(%{stack: [_]}, "over"), do: raise(Forth.StackUnderflow)

  def run_operation(%{stack: [h1, h2 | t]} = ev, "over") do
    %{ev | stack: [h2, h1, h2 | t]}
  end

  def run_operation(_, _), do: nil

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(ev) do
    Enum.reverse(ev.stack)
    |> Enum.join(" ")
  end

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
