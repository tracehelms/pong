defmodule Pong.GameServer do
  use GenServer
  alias Pong.GameEngine

  def start_link do
   GenServer.start_link(__MODULE__, :ok, [])
  end

  def init(:ok) do
    {:ok, Pong.GameEngine.new_game_state}
  end

  def get_state(server) do
    GenServer.call(server, {:get_state})
  end

  def move_player(server, player_side, direction) when player_side == :left or player_side == :right do
    GenServer.cast(server, {:move_player, player_side, direction})
  end

  def advance_game(server) do
    GenServer.call(server, {:advance_game})
  end

  # def start_game do
  # end
  #
  # def move_ball do
  # end

  # def score_point(player_side) do
  # end

  # call is synchronous, must send response
  # cast is async, doesn't have to send response

  def handle_call({:get_state}, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_cast({:move_player, player_side, direction}, state) do
    state = case direction do
      :up ->
        put_in(state, [player_side, :moving], direction)
      :down ->
        put_in(state, [player_side, :moving], direction)
      _ ->
        put_in(state, [player_side, :moving], :nope)
    end

    {:noreply, state}
  end

  def handle_call({:advance_game}, _from, state) do
    new_state = state
    |> GameEngine.move_ball
    |> GameEngine.move_paddle(:left)
    |> GameEngine.move_paddle(:right)
    # |> GameEngine.check_paddle_collisions
    # |> GameEngine.check_wall_collisions
    |> GameEngine.print_to_console

    {:reply, {:ok, new_state}, new_state}
  end
end
