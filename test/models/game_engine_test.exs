defmodule Pong.GameEngineTest do
  use ExUnit.Case, async: true
  alias Pong.GameEngine

  test "should move a player paddle up and down" do
    state = GameEngine.new_game_state

    assert GameEngine.move_paddle(state, :left).left.location == {20, 190}

    state = put_in(state, [:left, :moving], :down)
    assert GameEngine.move_paddle(state, :left).left.location == {20, 210}

    state = put_in(state, [:left, :moving], :up)
    assert GameEngine.move_paddle(state, :left).left.location == {20, 170}

    state = put_in(state, [:left, :location], {20, 0})
    state = put_in(state, [:left, :moving], :up)
    assert GameEngine.move_paddle(state, :left).left.location == {20, 0}

    state = put_in(state, [:left, :location], {20, 370})
    state = put_in(state, [:left, :moving], :down)
    assert GameEngine.move_paddle(state, :left).left.location == {20, 390}

    state = put_in(state, [:left, :location], {20, 380})
    state = put_in(state, [:left, :moving], :down)
    assert GameEngine.move_paddle(state, :left).left.location == {20, 380}
  end

  test "should start moving ball for new game" do
    state = GameEngine.move_ball(GameEngine.new_game_state)
    assert state.ball_velocity == {20, 20}
    assert state.ball_location == {310, 230}
  end

  test "should move ball on already started game" do
    state = GameEngine.new_game_state
    |> Map.put(:ball_velocity, {20, 20})
    |> GameEngine.move_ball

    assert state.ball_location == {330, 250}

    state = GameEngine.move_ball(state)
    assert state.ball_location == {350, 270}
  end

  test "ball should bounce off of the top and bottom walls" do
    state = GameEngine.new_game_state
    |> Map.put(:ball_velocity, {20, 20})
    |> Map.put(:ball_location, {310, 480})

    state = GameEngine.check_wall_collisions(state)
    assert state.ball_location == {310, 480}
    assert state.ball_velocity == {20, -20}

    state = state
    |> Map.put(:ball_location, {310, 0})
    |> GameEngine.check_wall_collisions

    assert state.ball_location == {310, 0}
    assert state.ball_velocity == {20, 20}
  end

end
