defmodule Servy.Parser do
  alias Servy.Conv, as: Conv

  def parse(request) do
    [top, params_string] = String.split(request, "\n\n")

    [request_line | header_lines] = String.split(top, "\n")

    [method, path, _version] = String.split(request_line, " ")

    header = parse_header(header_lines)
    params = parse_params(header["Content-Type"], params_string)

    %Conv{
      method: method,
      path: path,
      params: params,
      header: header
    }
  end

  # def parse_header([], headers), do: headers

  # def parse_header([head | tail], headers) do
  #   [key, value] = String.split(head, ": ")
  #   headers = Map.put(headers, key, value)
  #   parse_header(tail, headers)
  # end

  # def parse_header(lines) do
  #   Enum.reduce(
  #     lines,
  #     %{},
  #     fn line, acc ->
  #       [key, value] = String.split(line, ": ")
  #       Map.put(acc, key, value)
  #     end
  #   )
  # end

  def parse_header(lines) do
    Enum.reduce(
      lines,
      %{},
      &parse_header_line/2
    )
  end

  defp parse_header_line(line, acc) do
    [key, value] = String.split(line, ": ")
    Map.put(acc, key, value)
  end

  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string
    |> String.trim()
    |> URI.decode_query()
  end

  def parse_params(_, _), do: %{}
end
