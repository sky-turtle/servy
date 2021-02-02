defmodule Servy.Plugins do
  require Logger

  def track(%{status: 404, path: path} = conv) do
    Logger.info("You got a 404")
    IO.puts("Warning #{path} is on the loose!")
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{path: path} = conv) do
    regex = ~r{\/(?<animal>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  def rewrite_path(conv), do: conv

  @spec rewrite_path_captures(any, nil | map) :: any
  def rewrite_path_captures(conv, %{"animal" => animal, "id" => id}) do
    %{conv | path: "/#{animal}/#{id}"}
  end

  def rewrite_path_captures(conv, nil), do: conv

  def log(conv), do: IO.inspect(conv)
end
