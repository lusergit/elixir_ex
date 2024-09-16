if Node.connect(:todo_system@localhost) == true do
  :rpc.call(:todo_system@localhost, System, :stop, [])
  IO.puts("Node terminated")
else
  IO.puts("Cannot connect to remote node todo_system@localhost")
end
