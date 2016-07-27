defmodule Pong.GameEngine do
  use GenServer

  def start_link do
   GenServer.start_link(__MODULE__, :ok, [])
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def create_game(server, game_id) do
    GenServer.call(server, {:create_game, game_id})
  end

  def get_game(server, game_id) do
    GenServer.call(server, {:get_game, game_id})
  end

  def delete_game(server, game_id) do
    GenServer.cast(server, {:delete_game, game_id})
  end

  def move_player(server, game_id, data) do
    GenServer.cast(server, {:move_player, game_id, data})
  end

  # call is synchronous, must send response
  # cast is async, doesn't have to send response

  def handle_call({:get_game, game_id}, _from, state) do
    {:reply, Map.fetch(state, game_id), state}
  end

  def handle_call({:create_game, game_id}, _from, state) do
    if Map.has_key?(state, game_id) do
      {:noreply, state}
    else
      new_game_data = %{
        left: [0, 0],
        right: [0, 0],
        ball: [0, 0]
      }
      new_state = Map.put(state, game_id, new_game_data)
      {:reply, {:ok, game_id}, new_state}
    end
  end

  def handle_cast({:delete_game, game_id}, state) do
    {:noreply, Map.delete(state, game_id)}
  end

  def handle_cast({:move_player, game_id, {player_side, new_location}}, state) do
    game_state = Map.fetch!(state, game_id)
    |> Map.put(player_side, new_location)

    {:noreply, Map.put(state, game_id, game_state)}

  end
end
