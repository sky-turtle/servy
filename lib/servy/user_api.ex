defmodule Servy.UserApi do
  def query(_user_id) do
    response = send_request()
    get_city(response)
  end

  def send_request() do
    case HTTPoison.get("https://jsonplaceholder.typicode.com/users/1") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body

      {:ok, %HTTPoison.Response{status_code: status, body: _body}} ->
        status

      {:error, %HTTPoison.Error{id: _id, reason: reason}} ->
        reason
    end
  end

  def get_city(body) do
    body_map = Poison.Parser.parse!(body, %{})
    get_in(body_map, ["address", "city"])
  end
end
