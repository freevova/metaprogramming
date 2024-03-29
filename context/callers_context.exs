defmodule Mod do
  defmacro definfo do
    # Elixir.Mod
    IO.puts("In macro's context (#{__MODULE__}).")

    quote do
      # Elixir.MyModule
      IO.puts("In caller's context (#{__MODULE__}).")
      # Elixir.Mod
      IO.puts("In macro's context (#{unquote(__MODULE__)}).")

      def friendly_info do
        IO.puts("""
        My name is #{__MODULE__}
        My functions are #{inspect(__info__(:functions))}
        """)
      end

      def friendly_info(bar) do
        IO.puts(bar)
      end
    end
  end
end

defmodule MyModule do
  require Mod
  Mod.definfo()
end
