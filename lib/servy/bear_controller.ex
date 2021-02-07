defmodule Servy.BearController do
  alias Servy.Bear
  alias Servy.Wildthings

  defp bear_item(bear) do
    "<li>#{bear.name} - #{bear.type}</li>"
  end

  def index(conv) do
    items =
      Wildthings.list_bears()
      |> Enum.filter(&Bear.is_grizzly/1)
      |> Enum.sort(&Bear.order_by_asc_name/2)
      |> Enum.map(&bear_item/1)
      |> Enum.join()

    %{conv | status: 200, resp_body: "<ul>#{items}</ul>"}
  end

  def show(conv, %{"id" => id} = _params) do
    bear = Wildthings.get_bear(id)

    %{conv | status: 200, resp_body: "Bear #{bear.id}"}
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
