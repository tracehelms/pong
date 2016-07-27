defmodule Pong.GameEngineTest do
  use ExUnit.Case, async: true
  alias Pong.GameEngine

  setup do
    {:ok, server} = GameEngine.start_link
    {:ok, server: server}
  end

  test "starts a game", %{server: server} do
    assert GameEngine.get_game(server, 1) == :error

    {:ok, game_id} = GameEngine.create_game(server, 1)
    assert game_id == 1

    {:ok, game_state} = GameEngine.get_game(server, game_id)
    assert game_state == %{
      left: [0, 0],
      right: [0, 0],
      ball: [0, 0]
    }
  end

  test "should handle more than one game", %{server: server} do
    {:ok, game_one} = GameEngine.create_game(server, 1)
    {:ok, game_two} = GameEngine.create_game(server, 2)

    game_state = %{
      left: [0, 0],
      right: [0, 0],
      ball: [0, 0]
    }

    assert {:ok, game_state} == GameEngine.get_game(server, game_one)
    assert {:ok, game_state} == GameEngine.get_game(server, game_two)
  end

  test "should delete a game", %{server: server} do
    {:ok, game_id} = GameEngine.create_game(server, 1)
    assert {:ok, _game_state} = GameEngine.get_game(server, game_id)

    GameEngine.delete_game(server, game_id)

    assert GameEngine.get_game(server, game_id) == :error
  end

  test "should move a players paddle up and down", %{server: server} do
    {:ok, game_id} = GameEngine.create_game(server, 1)

    GameEngine.move_player(server, game_id, {:left, [0, 10]})
    {:ok, game_state} = GameEngine.get_game(server, game_id)

    assert game_state == %{
      left: [0, 10],
      right: [0, 0],
      ball: [0, 0]
    }
  end

end
