defmodule Servy.Wildthings do
  alias Servy.Bear

  def list_bears() do
    {:ok, json} = File.read("db/bears.json")
    %{"bears" => bears} = Poison.decode!(json, as: %{"bears" => [%Bear{}]})

    bears
  end

  def get_bear(id) when is_integer(id) do
    Enum.find(list_bears(), fn b -> b.id == id end)
  end

  def get_bear(id) when is_binary(id) do
    String.to_integer(id) |> get_bear()
  end
end
