defmodule Servy.Handler do
  @moduledoc """
  Handles HTTP requests.
  """
  @pages_path Path.expand("pages", File.cwd!())
  alias Servy.BearController
  alias Servy.Conv

  import Servy.FileHandler, only: [handle_file: 2]
  import Servy.Parser, only: [parse: 1]
  import Servy.Plugins, only: [track: 1, rewrite_path: 1, log: 1]

  @doc """
  Transforms the request into a response.
  """
  def handle(request) do
    request
    |> parse()
    |> rewrite_path
    |> log
    |> route()
    |> track()
    |> put_content_length()
    |> format_response()
  end

  def put_content_length(conv) do
    content_length =
      conv.resp_body
      |> String.length()

    new_headers = Map.put(conv.resp_headers, "Content-Length", content_length)

    %{conv | resp_headers: new_headers}
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    Servy.Api.BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv, conv.params)
  end

  def route(%Conv{method: "POST", path: "/api/bears"} = conv) do
    Servy.Api.BearController.create(conv, conv.params)
  end

  def route(%Conv{method: "DELETE", path: "/bears" <> _id} = conv) do
    BearController.delete(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} here!"}
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: #{conv.resp_headers["Content-Type"]}\r
    Content-Length: #{conv.resp_headers["Content-Length"]}\r
    \r
    #{conv.resp_body}
    """
  end
end
