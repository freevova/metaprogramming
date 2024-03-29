defmodule I18n do
  use Translator

  locale "en",
    flash: [
      hello: "Hello %{first} %{last}!",
      bye: "Bye, %{name}!"
    ],
    users: [
      title: "Users"
    ]

  locale "fr",
    flash: [
      hello: "Salut %{first} %{last}!",
      bye: "Au revoir, %{name}!"
    ],
    users: [
      title: "Utilisateurs"
    ]
end

# iex> I18n.t("en", "flash.hello", first: "Chris", last: "McCord")
# "Hello Chris Mccord!"
#
# iex> I18n.t("fr", "flash.hello", first: "Chris", last: "McCord")
# "Salut Chris McCord!"
#
# iex> I18n.t("en", "users.title")
# "Users"
#
# I18n.t("en", "flash.hello", first: "Chris", last: "McCord")
# "Hello Chris Mccord!"
#
# iex> I18n.t("en", "users.title")
# "Users"
