defmodule Servy.PledgeServer do
  def listen_loop(state) do
    IO.puts("\nWaiting for a message...")

    receive do
      {:create_pledge, name, amount} ->
        new_state = [{name, amount} | state]
        IO.puts("#{name} made a pledge for $#{amount} dollars")
        IO.puts("#{inspect(new_state)}")
        listen_loop(new_state)

      {sender, :recent_pledges} ->
        send(sender, {:response, state})
        IO.puts("Sent pledges to #{inspect(sender)}")
        listen_loop(state)
    end
  end

  # def create_pledge(name, amount) do
  #   {:ok, id} = send_pledge_to_service(name, amount)
  # end

  # def recent_pledges() do
  # end

  defp send_pledge_to_service(_name, _amount) do
    # This code would send the pledge to an external service
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end
