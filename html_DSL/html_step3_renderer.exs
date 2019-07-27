defmodule Template do
  import Html
  def render do
    markup do
      div id: "main" do
        h1 class: "title" do
          text "Welcome!"
        end
      end
      div class: "row" do
        div do
        p do: text "Hello!"
        end
      end
    end
  end
end

# iex> c "html_step3.exs"
# [Html]
#
# iex> c "html_step3_render.exs"
# [Template]
#
# iex> Template.render
# "<div id=\"main\"><h1 class=\"title\">Welcome!</h1>
# </div><div class=\"row\"><div><p>Hello!</p></div></div>"
