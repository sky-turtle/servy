defmodule Servy.FourOhFourCounter do
  @doc """
  Exercise for Stateful Server Processes
  """
  @name __MODULE__

  def start(initial_state \\ [%{}]) do
    IO.puts("Starting FourOhFourCounter server...")
    pid = spawn(__MODULE__, :listen_loop, initial_state)
    Process.register(pid, @name)
    pid
  end

  def bump_count(path) do
    send(@name, {self(), :bump_count, path})

    receive do
      {:response, new_count} -> new_count
    end
  end

  def get_count(path) do
    send(@name, {self(), :get_count, path})

    receive do
      {:response, count} -> count
    end
  end

  def get_counts() do
    send(@name, {self(), :get_counts})

    receive do
      {:response, counts} -> counts
    end
  end

  def listen_loop(state) do
    receive do
      {sender, :bump_count, path} ->
        new_state = Map.update(state, path, 1, fn x -> x + 1 end)
        send(sender, {:response, new_state})
        listen_loop(new_state)

      {sender, :get_count, path} ->
        count_for_path = Map.get(state, path)
        send(sender, {:response, count_for_path})
        listen_loop(state)

      {sender, :get_counts} ->
        send(sender, {:response, state})
        listen_loop(state)
    end
  end
end
