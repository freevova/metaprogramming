# This is an example of unquote fragments:

defmodule Fragments do
  for {name, val} <- [one: 1, two: 2, three: 3] do
    def unquote(name)(), do: unquote(val)
  end
end

# iex> Fragments.one
# 1
#
# iex> Fragments.two
# 2
