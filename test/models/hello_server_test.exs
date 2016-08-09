defmodule Pong.HelloServerTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, server} = GenServer.start_link(Pong.HelloServer, [])
    {:ok, server: server}
  end

  test "hello call", %{server: server} do
    {:ok, value} = GenServer.call(server, {:hello})
    assert value == :world
  end

  test "hello cast", %{server: server} do
    assert GenServer.cast(server, :hello) == :ok
  end

end
