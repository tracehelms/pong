defmodule Pong.StackServerTest do
  use ExUnit.Case, async: true
  alias Pong.StackServer

  setup do
    {:ok, server} = GenServer.start_link(StackServer, [])
    {:ok, server: server}
  end

  @tag :skip
  test "can add an item to list", %{server: server} do
    GenServer.cast(server, {:add, :hello})

    {:ok, list} = GenServer.call(server, {:get_state})
    assert list == [:hello]
  end

  @tag :skip
  test "can add two items to list", %{server: server} do
    GenServer.cast(server, {:add, :hello})
    GenServer.cast(server, {:add, :wat})

    {:ok, list} = GenServer.call(server, {:get_state})
    assert list == [:wat, :hello]
  end

  @tag :skip
  test "can pop an item in the stack", %{server: server} do
    GenServer.cast(server, {:add, :hello})
    GenServer.cast(server, {:add, :wat})

    assert GenServer.call(server, {:pop}) == {:ok, :wat}

    {:ok, list} = GenServer.call(server, {:get_state})
    assert list == [:hello]
  end

  @tag :skip
  test "interface can add", %{server: server} do
    StackServer.add(server, :hello)
    StackServer.add(server, :wat)

    {:ok, list} = StackServer.get_state(server)
    assert list == [:wat, :hello]
  end

  @tag :skip
  test "interface can pop", %{server: server} do
    StackServer.add(server, :hello)
    StackServer.add(server, :wat)

    assert StackServer.pop(server) == {:ok, :wat}

    {:ok, list} = StackServer.get_state(server)
    assert list == [:hello]
  end

end
