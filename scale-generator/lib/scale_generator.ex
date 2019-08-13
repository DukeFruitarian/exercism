defmodule ScaleGenerator do
  @doc """
  Find the note for a given interval (`step`) in a `scale` after the `tonic`.

  "m": one semitone
  "M": two semitones (full tone)
  "A": augmented second (three semitones)

  Given the `tonic` "D" in the `scale` (C C# D D# E F F# G G# A A# B C), you
  should return the following notes for the given `step`:

  "m": D#
  "M": E
  "A": F
  """
  @steps %{
    "m" => 1,
    "M" => 2,
    "A" => 3
  }

  @tones ~w(A A# B C C# D D# E F F# G G#)

  defguard is_flat_tonic(note, postfix)
           when (note in ~w(a b c d e f g) and postfix == "") or postfix == "b"

  @spec step(scale :: list(String.t()), tonic :: String.t(), step :: String.t()) ::
          list(String.t())
  def step(scale, tonic, step) do
    Stream.cycle(scale)
    |> Enum.at(get_index(scale, tonic) + @steps[step])
  end

  defp get_index(scale, tonic) do
    Enum.find_index(scale, &(&1 == String.capitalize(tonic)))
  end

  @doc """
  The chromatic scale is a musical scale with thirteen pitches, each a semitone
  (half-tone) above or below another.

  Notes with a sharp (#) are a semitone higher than the note below them, where
  the next letter note is a full tone except in the case of B and E, which have
  no sharps.

  Generate these notes, starting with the given `tonic` and wrapping back
  around to the note before it, ending with the tonic an octave higher than the
  original. If the `tonic` is lowercase, capitalize it.

  "C" should generate: ~w(C C# D D# E F F# G G# A A# B C)
  """
  @spec chromatic_scale(tonic :: String.t()) :: list(String.t())
  def chromatic_scale(tonic \\ "C") do
    get_chromatic_scale(tonic)
  end

  defp get_chromatic_scale(tones \\ @tones, tonic) do
    Stream.cycle(tones)
    |> Enum.slice(get_index(tones, tonic), 13)
  end

  @doc """
  Sharp notes can also be considered the flat (b) note of the tone above them,
  so the notes can also be represented as:

  A Bb B C Db D Eb E F Gb G Ab

  Generate these notes, starting with the given `tonic` and wrapping back
  around to the note before it, ending with the tonic an octave higher than the
  original. If the `tonic` is lowercase, capitalize it.

  "C" should generate: ~w(C Db D Eb E F Gb G Ab A Bb B C)
  """
  @spec flat_chromatic_scale(tonic :: String.t()) :: list(String.t())
  def flat_chromatic_scale(tonic \\ "C") do
    convert_to_flat()
    |> get_chromatic_scale(tonic)
  end

  defp convert_to_flat(tones \\ @tones) do
    Enum.reverse(tones)
    |> convert_tones()
    |> Enum.reverse()
  end

  defp convert_tones(tones) do
    Enum.scan(tones, Enum.at(tones, -1), &convert_tone/2)
  end

  defp convert_tone(<<_tone::binary-1, "#">>, prev_tone), do: prev_tone <> "b"
  defp convert_tone(<<_tone::binary-1, "b">>, prev_tone), do: prev_tone <> "#"
  defp convert_tone(tone, _prev_tone), do: tone

  @doc """
  Certain scales will require the use of the flat version, depending on the
  `tonic` (key) that begins them, which is C in the above examples.

  For any of the following tonics, use the flat chromatic scale:

  F Bb Eb Ab Db Gb d g c f bb eb

  For all others, use the regular chromatic scale.
  """
  @spec find_chromatic_scale(tonic :: String.t()) :: list(String.t())

  def find_chromatic_scale(<<note::binary-1, postfix::binary>>)
      when is_flat_tonic(note, postfix) do
    convert_to_flat()
    |> get_chromatic_scale(note <> postfix)
  end

  def find_chromatic_scale(tonic) do
    get_chromatic_scale(tonic)
  end

  @doc """
  The `pattern` string will let you know how many steps to make for the next
  note in the scale.

  For example, a C Major scale will receive the pattern "MMmMMMm", which
  indicates you will start with C, make a full step over C# to D, another over
  D# to E, then a semitone, stepping from E to F (again, E has no sharp). You
  can follow the rest of the pattern to get:

  C D E F G A B C
  """
  @spec scale(tonic :: String.t(), pattern :: String.t()) :: list(String.t())
  def scale(<<note::binary-1, postfix::binary>>, pattern) when is_flat_tonic(note, postfix) do
    convert_to_flat()
    |> do_scale(note <> postfix, pattern)
  end

  def scale(tonic, pattern) do
    do_scale(tonic, pattern)
  end

  def do_scale(current_scale \\ @tones, tonic, pattern) do
    patternized_scale =
      String.graphemes(pattern)
      |> Enum.flat_map_reduce(tonic, fn current_step, current_tonic ->
        next_tonic = step(current_scale, current_tonic, current_step)

        {[next_tonic], next_tonic}
      end)
      |> elem(0)

    [String.capitalize(tonic) | patternized_scale]
  end
end
