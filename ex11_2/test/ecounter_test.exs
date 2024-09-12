defmodule EcounterTest do
  use ExUnit.Case
  doctest Ecounter

  test "First event entry is 0" do
    pid = Ecounter.start()
    event_name = "Event"

    # should initialize the event to zero
    send(pid, {:event, event_name})

    # check
    send(pid, {:fetch, self(), event_name})

    val =
      receive do
        v -> v
      end

    assert val == {:events_count, {:ok, 0}}
  end

  test "Retrive an unknown event returns an error" do
    pid = Ecounter.start()

    send(pid, {:fetch, self(), "Unknown event"})

    val =
      receive do
        v -> v
      end

    assert val == {:events_count, {:error, :event_not_found}}
  end
end
