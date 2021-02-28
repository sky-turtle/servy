defmodule HttpServerTest do
  use ExUnit.Case

  alias Servy.PledgeServer

  PledgeServer.start()

  test "PledgeServer holds 3 pledges max in cache" do
    PledgeServer.create_pledge("larry", 10)
    PledgeServer.create_pledge("moe", 20)
    PledgeServer.create_pledge("curly", 30)
    PledgeServer.create_pledge("daisy", 40)
    PledgeServer.create_pledge("grace", 50)

    recent_pledges_count = PledgeServer.recent_pledges() |> Enum.count()

    assert recent_pledges_count == 3
  end

  test "PledgeServer cache has 3 most recent pledges" do
    PledgeServer.create_pledge("larry", 10)
    PledgeServer.create_pledge("moe", 20)
    PledgeServer.create_pledge("turtle", 30)
    PledgeServer.create_pledge("shawee", 40)
    PledgeServer.create_pledge("grace", 50)

    most_recent_pledges = [{"grace", 50}, {"shawee", 40}, {"turtle", 30}]

    assert PledgeServer.recent_pledges() == most_recent_pledges
  end
end
