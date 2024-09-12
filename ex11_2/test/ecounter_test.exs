defmodule EcounterTest do
  use ExUnit.Case
  doctest Ecounter

  test "greets the world" do
    assert Ecounter.hello() == :world
  end
end
