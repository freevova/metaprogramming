defmodule MimeMapper do
  use Mime, "text/emoji": [".emj"],
            "text/elixir": [".exs"]
end

# iex> MimeMapper.exts_for_type("text/elixir")
# [".exs"]
#
# iex> MimeMapper.exts_for_type("text/html")
# [".html"]
