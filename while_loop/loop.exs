defmodule Loop do
  defmacro while(expression, do: block) do
    quote do
      try do
        for _ <- Stream.cycle([:ok]) do
          if unquote(expression) do
            unquote(block)
          else
            Loop.break
          end
        end
      catch
        :break -> :ok
      end
    end
  end

  def break, do: throw :break
end

# iex> c "while.exs"
# [Loop]
#
# iex> import Loop
# nil
#
# iex>
# pid = spawn fn ->
#   while true do
#     receive do
#       :stop ->
#         IO.puts "Stopping..."
#         break
#       message ->
#         IO.puts "Got #{inspect message}"
#     end
#   end
# end
# #PID<0.93.0>
#
# iex> send pid, :hello
# Got :hello
# :hello
#
# iex> send pid, :ping
# Got :ping
# :ping
#
# iex> send pid, :stop
# Stopping...
# :stop
#
# iex> Process.alive? pid
# false
