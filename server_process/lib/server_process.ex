defmodule ServerProcess do
  @moduledoc """
  GenServer clone, boilerplate code
  """

  defp loop(callback_module, current_state) do
    receive do
      {:call, request, caller} ->
        {response, new_state} = callback_module.handle_call(request, current_state)
        send(caller, {:response, response})
        loop(callback_module, new_state)

      {:cast, request} ->
        new_state =
          callback_module.handle_cast(
            request,
            current_state
          )

        loop(callback_module, new_state)
    end
  end

  @doc """
  Casting a request, in contrat to `call`ing it does not wait for a response (asyncronous)
  """
  def cast(server_pid, request) do
    send(server_pid, {:cast, request})
  end

  @doc """
  Call the `callback_module` to perform some request
  """
  def call(server_pid, request) do
    send(server_pid, {:call, request, self()})

    receive do
      {:response, response} ->
        response
    end
  end

  @doc """
  Start function, start the server using `callback_module` to handle calls.
  """
  def start(callback_module) do
    spawn(fn ->
      initial_state = callback_module.init()
      loop(callback_module, initial_state)
    end)
  end
end

defmodule KeyValueStore do
  def init do
    %{}
  end

  def handle_cast({:put, key, value}, state) do
    {:ok, Map.put(state, key, value)}
  end

  def handle_call({:get, key}, state) do
    {Map.get(state, key), state}
  end

  def start do
    ServerProcess.start(KeyValueStore)
    |> Process.register(:kvstore)
  end

  def put(key, value) do
    ServerProcess.cast(:kvstore, {:put, key, value})
  end

  def get(key) do
    ServerProcess.call(:kvstore, {:get, key})
  end
end
