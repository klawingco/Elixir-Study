defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "create_deck makes 20 cards" do
    deck_length = length(Cards.create_deck)
    assert deck_length == 20
  end

  test "shuffling the deck randomizes it" do
    deck = Cards.create_deck
    refute deck == Cards.shuffle(deck)
  end

  test "create_hand will execute create_deck, shuffle and return hand" do
    {hand, _deck} = Cards.create_hand(2)
    assert length(hand) == 2
  end
end
