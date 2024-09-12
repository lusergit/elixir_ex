defmodule Ecounter do
  @moduledoc """
  Documentation for `Ecounter`.
  """

  defp loop(map) do
    receive do
      {:event, event} ->
        loop(Map.update(map, event, 0, fn val -> val + 1 end))

      {:fetch, pid, event} ->
        result =
          case Map.fetch(map, event) do
            :error -> {:error, :event_not_found}
            v -> v
          end

        response = {:events_count, result}
        send(pid, response)
    end

    loop(map)
  end

  @doc """
  Start server
  """
  def start do
    spawn(fn -> loop(%{}) end)
  end
end
