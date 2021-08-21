defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    request = request |> String.trim()
    [top | params_list] = String.split(request, "\r\n\r\n")

    [req_string | headers_list] = String.split(top, "\r\n")
    [method, path, _] = String.split(req_string, " ")

    params = get_params(params_list)

    headers = parse_headers(headers_list, %{})
    # IO.inspect headers_list

    %Conv{ method: method, path: path, params: params, headers: headers}
  end

  def get_params([]), do: %{}

  def get_params(params_list) do
    [params_string | tail] = params_list
    params_string |> parse_params
  end

  def parse_params(str) do
    str |> String.trim |> URI.decode_query
  end

  def parse_headers([hd | tail], map) do
    [key, value] = hd |> String.split(": ")
    map = Map.put(map, key, value)
    parse_headers(tail, map)
  end

  def parse_headers([], map), do: map
end
