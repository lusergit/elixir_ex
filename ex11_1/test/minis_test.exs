defmodule MinisTest do
  use ExUnit.Case
  doctest Minis

  test "Counter starts at 0" do
    pid = Minis.start()
    send(pid, {:get, self()})

    receive do
      {:ok, counter} ->
        assert counter == 0

      _ ->
        raise "Counter retrieve error"
    end
  end

  test "`:inc` actually increments" do
    pid = Minis.start()
    send(pid, :inc)
    send(pid, {:get, self()})

    receive do
      {:ok, counter} ->
        assert counter == 1

      _ ->
        raise "Counter retrieve error"
    end
  end

  test "`:dec` actually decrements" do
    pid = Minis.start()
    send(pid, :inc)
    send(pid, :inc)
    send(pid, :dec)
    send(pid, {:get, self()})

    receive do
      {:ok, counter} ->
        assert counter == 1

      _ ->
        raise "Counter retrieve error"
    end
  end
end
