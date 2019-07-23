defmodule Mime do
  @external_resource mimes_path = Path.join([__DIR__, "mimes.txt"])

  for line <- File.stream!(mimes_path, [], :line) do
    [type, rest] = line |> String.split(~r/\s/, parts: 2) |> Enum.map(&String.trim(&1))
    extensions = String.split(rest, ~r/,\s?/)

    def exts_from_type(unquote(type)), do: unquote(extensions)
    def type_from_ext(ext) when ext in unquote(extensions), do: unquote(type)
  end

  def exts_from_type(_type), do: []
  def type_from_ext(_ext), do: nil
  def valid_type?(type), do: exts_from_type(type) |> Enum.any?
end

# iex> c "mime.exs"
# [Mime]
#
# iex> Mime.exts_from_type("image/jpeg")
# [".jpeg", ".jpg"]
#
# iex> Mime.type_from_ext(".jpg")
# "image/jpeg"
#
# iex> Mime.valid_type?("text/html")
# true
#
# iex> Mime.valid_type?("text/emoji")
# false
