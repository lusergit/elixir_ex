defmodule TodoTest do
  use ExUnit.Case
  doctest Todo

  test "Application starts when module inits" do
    assert Application.ensure_started(:todo)
  end

  test "Cache reuses pids for the same lists" do
    bob_1 = Todo.Cache.server_process("Bob")
    bob_2 = Todo.Cache.server_process("Bob")

    assert bob_1 == bob_2
  end

  test "Cache uses different servers for different lists" do
    bob = Todo.Cache.server_process("Bob")
    alice = Todo.Cache.server_process("Alice")

    assert bob != alice
  end
end
