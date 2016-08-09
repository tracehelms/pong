defmodule Pong.StackServer do
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


  def handle_call({:get_state}, _from, state) do
    {:reply, {:ok, state}, state}
  end

end
