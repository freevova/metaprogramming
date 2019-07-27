defmodule Hub do
  HTTPoison.start
  @username "freevova"

  with {:ok, response} <- "https://api.github.com/users/#{@username}/repos"
                          |> HTTPoison.get(["User-Agent": "Elixir"]) do

    response
    |> Map.get(:body)
    |> Poison.decode!
    |> Enum.each(fn repo ->
      def unquote(String.to_atom(repo["name"]))() do
        unquote(Macro.escape(repo))
      end
    end)
  end

  def go(repo) do
    url = apply(__MODULE__, repo, [])["git_url"]
    IO.puts "Launching browser to #{url}..."
    # System.cmd("open", [url]) DEPENDS ON OS
  end
end


# iex> Hub.linguist
# %{"description" => "Elixir Internationalization library",
# "full_name" => "chrismccord/linguist",
# "git_url" => "git://github.com/chrismccord/linguist.git",
# "open_issues" => 4, "open_issues_count" => 4,
# "pushed_at" => "2014-08-04T13:28:30Z",
# "watchers" => 33,
# ...
# }
#
# iex> Hub.linguist["description"]
# "Elixir Internationalization library"
#
# iex> Hub.linguist["watchers"]
# 33
#
# iex> Hub.go :linguist
# Launching browser to https://github.com/chrismccord/linguist...
