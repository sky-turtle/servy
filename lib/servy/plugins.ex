defmodule Servy.Plugins do
  alias Servy.Conv
  require Logger

  def track(%{status: 404, path: path} = conv) do
    if Mix.env() != :test do
      IO.puts("Warning #{path} is on the loose!")
    end

    conv
  end

  def track(conv), do: conv

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

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

  def log(conv) do
    if Mix.env() == :dev do
      IO.inspect(conv)
    end

    conv
  end
end
