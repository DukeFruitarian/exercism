defmodule Poker do
  @doc """
  Given a list of poker hands, return a list containing the highest scoring hand.

  If two or more hands tie, return the list of tied hands in the order they were received.

  The basic rules and hand rankings for Poker can be found at:

  https://en.wikipedia.org/wiki/List_of_poker_hands

  For this exercise, we'll consider the game to be using no Jokers,
  so five-of-a-kind hands will not be tested. We will also consider
  the game to be using multiple decks, so it is possible for multiple
  players to have identical cards.

  Aces can be used in low (A 2 3 4 5) or high (10 J Q K A) straights, but do not count as
  a high card in the former case.

  For example, (A 2 3 4 5) will lose to (2 3 4 5 6).

  You can also assume all inputs will be valid, and do not need to perform error checking
  when parsing card values. All hands will be a list of 5 strings, containing a number
  (or letter) for the rank, followed by the suit.

  Ranks (lowest to highest): 2 3 4 5 6 7 8 9 10 J Q K A
  Suits (order doesn't matter): C D H S

  Example hand: ~w(4S 5H 4C 5D 4H) # Full house, 5s over 4s
  """
  @ranks [
    straight_flush: 9,
    four_of_a_kind: 8,
    full_house: 7,
    flush: 6,
    straight: 5,
    three_of_a_kind: 4,
    two_pairs: 3,
    pair: 2,
    high_card: 1
  ]

  @card_values %{
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "10" => 10,
    "J" => 11,
    "Q" => 12,
    "K" => 13,
    "A" => 14
  }

  defguard is_straight(a, b, c, d, e) when a == b + 1 and b == c + 1 and c == d + 1 and d == e + 1

  @spec best_hand(list(list(String.t()))) :: list(list(String.t()))
  def best_hand(hands) do
    Stream.map(hands, &decompose_hand/1)
    |> Enum.reduce([], &collect_win_hands/2)
    |> Stream.map(&Map.get(&1, :initial_hand))
    |> Enum.reverse()
  end

  defp collect_win_hands(hand, []), do: [hand]

  defp collect_win_hands(
         %{rank: rank, combination: combination, kickers: kickers} = hand,
         [%{rank: rank, combination: combination, kickers: kickers} | _] = win_hands
       ) do
    [hand | win_hands]
  end

  defp collect_win_hands(
         %{rank: rank, combination: combination, kickers: hand_kickers} = hand,
         [%{rank: rank, combination: combination, kickers: top_kickers} | _] = win_hands
       ) do
    if List.to_tuple(hand_kickers) > List.to_tuple(top_kickers) do
      [hand]
    else
      win_hands
    end
  end

  defp collect_win_hands(
         %{rank: rank, combination: hand_combination} = hand,
         [%{rank: rank, combination: top_combination} | _] = win_hands
       ) do
    if List.to_tuple(hand_combination) > List.to_tuple(top_combination) do
      [hand]
    else
      win_hands
    end
  end

  defp collect_win_hands(%{rank: hand_rank}, [%{rank: win_rank} | _] = win_hands)
       when win_rank > hand_rank do
    win_hands
  end

  defp collect_win_hands(hand, _win_hands), do: [hand]

  defp decomposed_hand_for_rank({name, value}, hand) do
    case apply(__MODULE__, String.to_atom("#{name}_rank"), [hand]) do
      {combination, kickers} ->
        %{
          rank: value,
          combination: combination,
          kickers: kickers,
          initial_hand: hand
        }

      _ ->
        nil
    end
  end

  defp decompose_hand(hand) do
    Enum.find_value(@ranks, &decomposed_hand_for_rank(&1, hand))
  end

  def straight_flush_rank(hand) do
    with {_combination, _kicker} <- flush_rank(hand),
         res = {_combination, _kicker} <- straight_rank(hand) do
      res
    end
  end

  def four_of_a_kind_rank(hand) do
    hand
    |> card_rank_values
    |> four_of_a_kind
  end

  defp four_of_a_kind([a, a, a, a, b]), do: {[a, a, a, a], [b]}
  defp four_of_a_kind([a, b, b, b, b]), do: {[b, b, b, b], [a]}
  defp four_of_a_kind(_), do: nil

  def full_house_rank(hand) do
    hand
    |> card_rank_values
    |> full_house
  end

  defp full_house([a, a, a, b, b]), do: {[a, a, a, b, b], []}
  defp full_house([a, a, b, b, b]), do: {[b, b, a, a, a], []}
  defp full_house(_), do: nil

  def flush_rank(hand) do
    suits_size =
      hand
      |> suits
      |> map_size()

    if suits_size == 1 do
      {card_rank_values(hand), []}
    end
  end

  def straight_rank(hand) do
    hand
    |> card_rank_values
    |> straight
  end

  defp straight([14, 5, 4, 3, 2]), do: {[5, 4, 3, 2, 1], []}
  defp straight([a, b, c, d, e]) when is_straight(a, b, c, d, e), do: {[a, b, c, d, e], []}
  defp straight(_), do: nil

  def three_of_a_kind_rank(hand) do
    hand
    |> card_rank_values
    |> three_of_a_kind
  end

  defp three_of_a_kind([a, a, a, b, c]), do: {[a, a, a], [b, c]}
  defp three_of_a_kind([a, b, b, b, c]), do: {[b, b, b], [a, c]}
  defp three_of_a_kind([a, b, c, c, c]), do: {[c, c, c], [a, b]}
  defp three_of_a_kind(_), do: nil

  def two_pairs_rank(hand) do
    hand
    |> card_rank_values
    |> two_pairs
  end

  defp two_pairs([a, a, b, b, c]), do: {[a, a, b, b], [c]}
  defp two_pairs([a, a, b, c, c]), do: {[a, a, c, c], [b]}
  defp two_pairs([a, b, b, c, c]), do: {[b, b, c, c], [a]}
  defp two_pairs(_), do: nil

  def pair_rank(hand) do
    hand
    |> card_rank_values
    |> pair
  end

  defp pair([a, a, b, c, d]), do: {[a, a], [b, c, d]}
  defp pair([a, b, b, c, d]), do: {[b, b], [a, c, d]}
  defp pair([a, b, c, c, d]), do: {[c, c], [a, b, d]}
  defp pair([a, b, c, d, d]), do: {[d, d], [a, b, c]}
  defp pair(_), do: nil

  def high_card_rank(hand) do
    {[], card_rank_values(hand)}
  end

  defp suits(hand) do
    Enum.group_by(hand, &get_suit/1)
  end

  defp get_suit(<<"10", suit::binary-1>>), do: suit
  defp get_suit(<<_::binary-1, suit::binary-1>>), do: suit

  defp card_rank_values(hand) do
    hand
    |> Stream.map(&get_card_rank/1)
    |> Enum.sort()
    |> Enum.reverse()
  end

  defp get_card_rank(<<"10", _>>), do: @card_values["10"]
  defp get_card_rank(<<rank::binary-1, _>>), do: @card_values[rank]
end
