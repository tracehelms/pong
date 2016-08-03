defmodule Pong.GameServerTest do
  use ExUnit.Case, async: true
  alias Pong.GameServer

  setup do
    {:ok, server} = GameServer.start_link
    {:ok, server: server}
  end

  test "initializes a game", %{server: server} do
    {:ok, game_state} = GameServer.get_state(server)
    assert game_state == %{
      score: {0, 0},
      left: %{
        location: {20, 190},
        moving: :nope
      },
      right: %{
        location: {608, 190},
        moving: :nope
      },
      ball_location: {310, 230},
      ball_velocity: {0, 0}
    }
  end

  test "should move a players paddle", %{server: server} do
    GameServer.move_player(server, :left, :down)
    {:ok, game_state} = GameServer.get_state(server)

    assert game_state.left.moving == :down

    GameServer.move_player(server, :right, :up)
    {:ok, game_state} = GameServer.get_state(server)

    assert game_state.right.moving == :up

    GameServer.move_player(server, :left, "wat")
    {:ok, game_state} = GameServer.get_state(server)

    assert game_state.left.moving == :nope
  end

end
