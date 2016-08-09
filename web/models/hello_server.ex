defmodule Pong.HelloServer do
  use GenServer

  # You need to make these tests pass
  #
  # GenServer.call callback signature looks like this:
  # def handle_call({:name, args}, _from, state) do ...
  #
  # And the return from that callback should look like this:
  # {:reply, {:ok, value}, new_state}


  # todo delete
  def handle_call({:hello}, _from, state) do
    {:reply, {:ok, :world}, state}
  end

  # This doesn't do anything, just for reference
  def handle_cast({:hello}, state) do
    new_state = state
    {:noreply, new_state}
  end

end
