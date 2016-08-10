defmodule Pong.GameServer do
  use GenServer
  alias Pong.GameEngine

  ####################################################
  # Interface
  ####################################################

  def start_link do
    GenServer.start_link(__MODULE__, Pong.GameEngine.new_game_state, [])
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

  def auto_advance(server) do
    {:ok, timer_pid} = :timer.apply_interval(:timer.seconds(2), __MODULE__, :advance_game, [server])
    IO.puts "Automatically running timer"
    IO.puts "To stop, run `:timer.cancel(timer_pid)`"

    timer_pid
  end

  ####################################################
  # Server implementation
  ####################################################

  def handle_call({:get_state}, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:advance_game}, _from, state) do
    new_state = state
    |> GameEngine.move_ball
    |> GameEngine.move_paddle(:left)
    |> GameEngine.move_paddle(:right)
    |> GameEngine.check_wall_collisions
    |> GameEngine.print_to_console

    # TODO
    # Implement the following checks in the GameEngine
    #
    # Check for paddle collisions
    # Check if a point was scored

    {:reply, {:ok, new_state}, new_state}
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
end
