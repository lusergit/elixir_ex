defmodule Todo do
  @moduledoc """
  Todo module, leveraging the Cache Server and Database
  modules to provide and API to use todo lists
  """

  @doc """
  Get a list identified by its name. This can be the user name or
  whatever, it should be a bitstring. It returns the `pid` of a server
  handling requests for that list.

  ## Example
      bob = Todo.get_list("Bob")
  """
  def get_list(name) do
    Todo.Cache.server_process(name)
  end

  @doc """

  Adds an entry for the given list. `server` is the server pid
  handling the requests for the specific list, while `date` and `todo`
  are the argument of the entry

  ## Example
      bob = Todo.get_list("bob")
      Todo.add_entry(bob, ~D[2024-09-14], "Dentist")
      # Will add the `Dentist` todo on the 14 sept 2024.

  """
  def add_entry(list, date, todo) do
    Todo.Server.add_entry(list, {date, todo})
  end

  @doc """

  Returns the spceific todo entries for a given day as a list of strings (the todos)

  ## Example
      bob = Todo.get_entries(~D[2024-09-14])
      # ["Dentist"]


  Entries persist in the `todo_db` folder of the current `pwd`
  """
  def get_entries(list, date) do
    Todo.Server.entries(list, date)
  end
end
