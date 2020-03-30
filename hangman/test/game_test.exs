defmodule GameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "new_game return structure" do

    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "state isn't changed for :won or :lost game" do
    for state <- [ :won, :lost ] do
      game = Game.new_game() |> Map.put(:game_state, state)
      assert {^game, _} = Game.make_move(game, "x")
    end
  end

  test "first occurence of letter is not already used" do
    game = Game.new_game()
    {game, _} = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second occurence of letter is not already used" do
    game = Game.new_game()
    {game, _} = Game.make_move(game, "x")
    assert game.game_state != :already_used

    {game, _} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("wibble")
    {game, _} = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a gussed word is a won game" do
    game = Game.new_game("wibble")
    {game, _} = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    {game, _} = Game.make_move(game, "i")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    {game, _} = Game.make_move(game, "b")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    {game, _} = Game.make_move(game, "l")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    {game, _} = Game.make_move(game, "e")
    assert game.game_state == :won
    assert game.turns_left == 7
  end

  test "bad guess is recognized" do
    game = Game.new_game("wibble")
    {game, _} = Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "lost game is recognized" do
    game = Game.new_game("w")
    {game, _} = Game.make_move(game, "a")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
    {game, _} = Game.make_move(game, "b")
    assert game.game_state == :bad_guess
    assert game.turns_left == 5
    {game, _} = Game.make_move(game, "c")
    assert game.game_state == :bad_guess
    assert game.turns_left == 4
    {game, _} = Game.make_move(game, "d")
    assert game.game_state == :bad_guess
    assert game.turns_left == 3
    {game, _} = Game.make_move(game, "e")
    assert game.game_state == :bad_guess
    assert game.turns_left == 2
    {game, _} = Game.make_move(game, "f")
    assert game.game_state == :bad_guess
    assert game.turns_left == 1
    {game, _} = Game.make_move(game, "g")
    assert game.game_state == :lost
  end

  test "a guessed word is a won game" do

    moves = [
      {"w", :good_guess},
      {"i", :good_guess},
      {"b", :good_guess},
      {"b", :already_used},
      {"l", :good_guess},
      {"e", :won},
    ]

    game = Game.new_game("wibble")

    fun = fn ({ guess, state }, game) ->
            {game, _} = Game.make_move(game, guess)
            assert game.game_state == state
            game
          end

    Enum.reduce(moves, game, fun)

  end
end
