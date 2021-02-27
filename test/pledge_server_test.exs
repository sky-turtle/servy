defmodule HttpServerTest do
  use ExUnit.Case, async: true

  alias Servy.PledgeServer

  test "server caches only the 3 most recent pledges" do
    PledgeServer.start()

    PledgeServer.create_pledge("larry", 10)
    PledgeServer.create_pledge("moe", 20)
    PledgeServer.create_pledge("curly", 30)
    PledgeServer.create_pledge("daisy", 40)
    PledgeServer.create_pledge("grace", 50)

    recent_pledges_count = PledgeServer.recent_pledges() |> Enum.count()

    assert recent_pledges_count == 3
  end
end
