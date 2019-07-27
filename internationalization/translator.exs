defmodule Translator do
  defmacro __using__(_options) do
    quote do
      Module.register_attribute __MODULE__, :locales, accumulate: true, persist: false
      import unquote(__MODULE__), only: [locale: 2]
      # IO.inspect(__MODULE__)          # I18n
      # IO.inspect(unquote(__MODULE__)) # Translator
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(env) do
    compile(Module.get_attribute(env.module, :locales))
  end

  defmacro locale(name, mappings) do
    quote bind_quoted: [name: name, mappings: mappings] do
      @locales {name, mappings}
    end
  end

  def compile(translations) do
    translations_ast = for {locale, mappings} <- translations do
      deftranslations(locale, "", mappings)
    end

    final_ast = quote do
      def t(locale, path, bindings \\ [])
      unquote(translations_ast)
      def t(_locale, _path, _bindings), do: {:error, :no_translation}
    end

    # IO.puts Macro.to_string(final_ast)
    final_ast
  end

  defp deftranslations(locale, current_path, mappings) do
    for {key, val} <- mappings do
      path = append_path(current_path, key)
      if Keyword.keyword?(val) do
        deftranslations(locale, path, val)
      else
        quote do
          def t(unquote(locale), unquote(path), bindings) do
            unquote(interpolate(val))
          end
        end
      end
    end
  end

  defp interpolate(string) do
    ~r/(?<head>)%{[^}]+}(?<tail>)/
    |> Regex.split(string, on: [:head, :tail])
    |> Enum.reduce("", fn
      <<"%{" <> rest>>, acc ->
        key = String.to_atom(String.trim_trailing(rest, "}"))
        quote do
          unquote(acc) <> to_string(Keyword.fetch!(bindings, unquote(key)))
        end
      segment, acc -> quote do: (unquote(acc) <> unquote(segment))
    end)
  end

  defp append_path("", next), do: to_string(next)
  defp append_path(current, next), do: "#{current}.#{next}"
end

# """
#   IO.puts Macro.to_string(final_ast) =>
#
# (
#   def(t(locale, path, binding \\ []))
#   [[[def(t("fr", "flash.hello", bindings)) do
#   (((("" <> "Salut ") <> to_string(Dict.fetch!(bindings, :first))) <> " ") <>
#   to_string(Dict.fetch!(bindings, :last))) <> "!"
#   end, def(t("fr", "flash.bye", bindings)) do
#   (("" <> "Au revoir, ") <> to_string(Dict.fetch!(bindings, :name))) <> "!"
#   end], [def(t("fr", "users.title", bindings)) do
#   "" <> "Utilisateurs"
#   end]], [[def(t("en", "flash.hello", bindings)) do
#   (((("" <> "Hello ") <> to_string(Dict.fetch!(bindings, :first))) <> " ") <>
#   to_string(Dict.fetch!(bindings, :last))) <> "!"
#   end, def(t("en", "flash.bye", bindings)) do
#   (("" <> "Bye, ") <> to_string(Dict.fetch!(bindings, :name))) <> "!"
#   end], [def(t("en", "users.title", bindings)) do
#   "" <> "Users"
#   end]]]
#   def(t(_locale, _path, _bindings)) do
#   {:error, :no_translation}
#   end
# )
