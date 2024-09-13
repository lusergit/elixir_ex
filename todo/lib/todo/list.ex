defmodule Todo.List do
  def new, do: %{}

  def add_entry(todo_list, {date, title}) do
    Map.update(todo_list, date, [title], fn titles -> [title | titles] end)
  end

  def entries(todo_list, date) do
    Map.get(todo_list, date, [])
  end

  def entries(todo_list) do
    todo_list
  end
end

# TODO: Reimplement with :ets
