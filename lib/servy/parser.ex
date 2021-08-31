defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    request = request |> String.trim()
    [top | params_list] = String.split(request, "\r\n\r\n")

    [req_string | headers_list] = String.split(top, "\r\n")
    [method, path, _] = String.split(req_string, " ")

    params = get_params(params_list, path)

    headers = parse_headers(headers_list, %{})
    # IO.inspect headers_list

    %Conv{ method: method, path: path, params: params, headers: headers}
  end

  def get_params([], path), do: %{}

  def get_params(params_list, path) do
    [params_string | tail] = params_list
    params_string |> parse_params(path)
  end

  def parse_params(str, path) do
    if String.match?(path, ~r/^\/api\//) do
      Poison.Parser.parse!(str, %{})
    else
      str |> String.trim |> URI.decode_query
    end
  end

  def parse_headers([hd | tail], map) do
    [key, value] = hd |> String.split(": ")
    map = Map.put(map, key, value)
    parse_headers(tail, map)
  end

  def parse_headers([], map), do: map
end
