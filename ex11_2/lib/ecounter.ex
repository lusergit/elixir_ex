defmodule Ecounter do
  @moduledoc """
  Documentation for `Ecounter`.
  """

  defp loop(map) do
    receive do
      {:event, event} ->
        loop(Map.update(map, event, 0, fn val -> val + 1 end))

      {:fetch, pid, event} ->
        send(
          pid,
          {:events_count,
           case Map.fetch(map, event) do
             :error -> {:error, :event_not_found}
             v -> v
           end}
        )
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
