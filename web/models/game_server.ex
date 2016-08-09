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
    # TODO - implement
  end

  def advance_game(server) do
    # TODO - implement
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

end
