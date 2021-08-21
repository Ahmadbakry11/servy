defmodule ParserTest do
  use ExUnit.Case
  doctest Servy.Parser

  alias Servy.Parser

  test "parsing headers list into a map" do
    headers_list = ["A: 1", "B: 2"]
    headers =  Parser.parse_headers(headers_list, %{})
    assert headers == %{"A" => "1", "B" => "2"}
  end

  test "parsing params list into a map of params" do
    params_list = ["name=Baloo&type=Brown"]
    params =  Parser.get_params(params_list)
    assert params == %{"name" => "Baloo", "type" => "Brown"}
  end
end
