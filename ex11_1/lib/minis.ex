defmodule Minis do
  defp loop(counter) when is_integer(counter) do
    receive do
      :inc ->
        loop(counter + 1)

      :dec ->
        loop(counter - 1)

      {:get, pid} ->
        send(pid, {:ok, counter})
        loop(counter)
    end
  end

  @doc """
  Start the counter server
  """
  def start() do
    spawn(fn -> loop(0) end)
  end
end
