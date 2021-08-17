defmodule Servy.Handler do
  import Servy.Plugins
  import Servy.Parser
  import Servy.FileHandler
  alias Servy.Conv
  alias Servy.BearsController

  @moduledoc """
    handle http requests
  """
  @pages_path Path.expand("../pages", __DIR__)

  def handle(request) do
    request
    |> parse
    |> redirect
    |> rewrite
    |> log
    |> route
    |> track
    |> emojify
    |> format_response
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    conv = %{ conv | status: 200, res_body: "Bears, Lions, Tigers" }
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearsController.index(conv)
    # conv = %{ conv | status: 200, res_body: "Teddy, Smokey, Paddington" }
  end

  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/"<>id} = conv) do
    params = Map.put(%{}, "id", id)
    BearsController.show(conv, params)
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearsController.create(conv, conv.params)
  end

  def route(%Conv{method: "DELETE", path: "/bears/"<>id} = conv) do
    params = Map.put(%{}, "id", id)
    BearsController.delete(conv, params)
  end


  # def route(%{method: "GET", path: "/about"} = conv) do
  #   file = Path.expand("../pages", __DIR__)
  #   |> Path.join("about.txt")
  #
  #   case File.read(file) do
  #     {:ok, content} ->
  #       conv = %{ conv | status: 200, res_body: content }
  #     {:error, reason} ->
  #       conv = %{ conv | status: 500, res_body: "File not found!" }
  #   end
  # end


  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.txt")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{path: path} = conv) do
    conv = %{conv | status: 404, res_body: "#{path}: No thing found"}
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.res_body)}

    #{conv.res_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "Ok",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found"
    }[code]
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com  def route(%{method: "DELETE", path: "/bears"<>id} = conv) do
    conv = %{ conv | status: 403, res_body: "Deleting bears is forbidden"}
  end
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request2 = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request3 = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request4 = """
DELETE /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request5 = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request6 = """
GET /bears?id=1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request7 = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request8 = """
GET /bears/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request9 = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=Baloo&type=Brown
"""

request10 = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

# response = Servy.Handler.handle(request)
# IO.puts response

# IO.inspect elem(Servy.Handler.all_bears(), 0)

response = Servy.Handler.handle(request3)
IO.puts response
