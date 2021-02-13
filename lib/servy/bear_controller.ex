defmodule Servy.BearController do
  alias Servy.Bear
  alias Servy.Wildthings

  import Servy.View, only: [render: 3]

  def index(conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_by_asc_name/2)

    render(conv, "index.eex", bears: bears)
  end

  def show(conv, %{"id" => id} = _params) do
    bear = Wildthings.get_bear(id)

    render(conv, "show.eex", bear: bear)
  end

  def create(conv, %{"type" => type, "name" => name} = _params) do
    %{
      conv
      | status: 201,
        resp_body: "Created a #{type} bear named #{name}"
    }
  end

  def delete(conv, _params) do
    %{conv | status: 403, resp_body: "Deleting a bear is forbidden"}
  end
end
