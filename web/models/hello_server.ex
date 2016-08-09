defmodule Pong.HelloServer do
  use GenServer

  # TODO - You need to make these tests pass
  #
  # GenServer callback signatures look like this:
  #
  # def handle_cast({:name, args, ...}, state) do
  #   {:noreply, new_state}
  # end
  #
  # def handle_call({:name, args}, _from, state) do
  #   {:reply, {:ok, value}, new_state}
  # end


  # This doesn't do anything, just for reference
  def handle_cast({:hello}, state) do
    new_state = state
    {:noreply, new_state}
  end

end
