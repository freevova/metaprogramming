defmodule Template do
  import Html

  def render do
    markup do
      table do
        tr do
          for i <- 0..5 do
            td do: text("Cell #{i}")
          end
        end
      end
      div do
        text "Some Nested Content"
      end
    end
  end
end

# iex> c "html_step2.exs"
# [Html]
#
# iex> c "html_step2_render.exs"
# [Template]
#
# iex> Template.render
# "<table><tr><td>Cell 0</td><td>Cell 1</td><td>Cell 2</td><td>Cell 3</td>
# <td>Cell 4</td><td>Cell 5</td></tr></table><div>Some Nested Content</div>"
