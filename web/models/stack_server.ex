defmodule Pong.StackServer do
  use GenServer

  # todo delete
  def add(server, item) do
    GenServer.cast(server, {:add, item})
  end

  # todo delete
  def pop(server) do
    GenServer.call(server, {:pop})
  end

  # todo delete
  def get_state(server) do
    GenServer.call(server, {:get_state})
  end

  # You need to make these tests pass
  #
  # GenServer callback signatures look like this:
  #
  # def handle_cast({:name, args, ...}, state) do ...
  #
  # def handle_call({:name, args}, _from, state) do ...

  # todo delete
  def handle_cast({:add, item}, state) do
    {:noreply, [item | state]}
  end

  # todo delete
  def handle_call({:pop}, _from, [head | tail]) do
    {:reply, {:ok, head}, tail}
  end

  def handle_call({:get_state}, _from, state) do
    {:reply, {:ok, state}, state}
  end

end
