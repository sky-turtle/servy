defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse()
    |> route()
    |> format_response()
  end

  def parse(request) do
    first_line = String.split(request, "\n") |> List.first() |> String.split(" ")
    [method, path, _] = first_line
    %{method: method, path: path, resp_body: ""}
  end

  def route(conv) do
    %{method: "GET", path: "/wildthings", resp_body: "Bears, Lions, Tigers"}
  end

  def format_response(conv) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 20

    Bears, Lions, Tigers
    """
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""


response = Servy.Handler.handle(request)
IO.puts(response)
