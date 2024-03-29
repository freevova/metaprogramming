defmodule Html do
  @external_resource tags_path = Path.join([__DIR__, "tags.txt"])
  @tags (for line <- File.stream!(tags_path, [], :line) do
    line |> String.strip |> String.to_atom
  end)

  defmacro markup(do: block) do
    quote do
      {:ok, var!(buffer, Html)} = start_buffer([])
      unquote(Macro.postwalk(block, &postwalk/1))
      result = render(var!(buffer, Html))
      :ok = stop_buffer(var!(buffer, Html))
      result
    end
  end

  def postwalk({:text, _meta, [string]}) do
    quote do: put_buffer(var!(buffer, Html), to_string(unquote(string)))
  end

  def postwalk({tag_name, _meta, [[do: inner]]}) when tag_name in @tags do
    quote do: tag(unquote(tag_name), [], do: unquote(inner))
  end

  def postwalk({tag_name, _meta, [attrs, [do: inner]]}) when tag_name in @tags do
    quote do: tag(unquote(tag_name), unquote(attrs), do: unquote(inner))
  end

  def postwalk(ast), do: ast

  def start_buffer(state), do: Agent.start_link(fn -> state end)

  def stop_buffer(buff), do: Agent.stop(buff)

  def put_buffer(buff, content), do: Agent.update(buff, &[content | &1])

  def render(buff), do: Agent.get(buff, &(&1)) |> Enum.reverse |> Enum.join("")

  defmacro tag(name, attrs \\ [], do: inner) do
    quote do
      put_buffer var!(buffer, Html), open_tag(unquote_splicing([name, attrs]))
      unquote(postwalk(inner))
      put_buffer var!(buffer, Html), unquote("</#{name}>")
    end
  end

  def open_tag(name, []), do: "<#{name}>"
  def open_tag(name, attrs) do
    attr_html = for {key, val} <- attrs, into: "", do: " #{key}=\"#{val}\""
    "<#{name}#{attr_html}>"
  end
end

# iex> c "html_macro_walk.exs"
# [Html]
#
# iex> import Html
# nil
#
# iex> ast = quote do
#   markup do
#     div do
#       h1 do
#         text "Some text"
#       end
#     end
#   end
# end
#
# iex> ast |> Macro.expand(__ENV__) |> Macro.to_string |> IO.puts
# (
#   {:ok, var!(buffer, Html)} = start_buffer([])
#   tag(:div, []) do
#     tag(:h1, []) do
#       put_buffer(var!(buffer, Html), to_string("Some text"))
#     end
#   end
#   result = render(var!(buffer, Html))
#   :ok = stop_buffer(var!(buffer, Html))
#   result
# )
# :ok
