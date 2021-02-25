defmodule HttpServerTest do
  use ExUnit.Case, async: true

  alias Servy.HttpServer

  test "accepts a request on a socket and sends back a response" do
    spawn(HttpServer, :start, [4000])

    caller_pid = self()

    max_concurrent_requests = 5

    for _ <- 1..max_concurrent_requests do
      spawn(fn ->
        {:ok, response} = HTTPoison.get("http://localhost:4000/wildthings")
        send(caller_pid, {:ok, response})
      end)
    end

    for _ <- 1..max_concurrent_requests do
      receive do
        {:ok, response} ->
          assert response.status_code == 200
          assert response.body == "Bears, Lions, Tigers"
      end
    end
  end
end
