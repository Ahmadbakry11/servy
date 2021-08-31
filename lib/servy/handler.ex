defmodule Servy.Handler do
  alias Servy.Conv
  import Servy.Plugins
  import Servy.Parser
  import Servy.FileHandler
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
    |> put_content_length
    |> format_response
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    conv = %{ conv | status: 200, res_body: "Bears, Lions, Tigers" }
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearsController.index(conv)
    # conv = %{ conv | status: 200, res_body: "Teddy, Smokey, Paddington" }
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    Servy.Api.BearsController.index(conv)
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

  def route(%Conv{method: "POST", path: "/api/bears"} = conv) do
    Servy.Api.BearsController.create(conv, conv.params)
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

  def route(%Conv{method: "GET", path: "/"<>name} = conv) do
    @pages_path
    |> Path.join("#{name}.md")
    |> File.read()
    |> handle_file(conv)
    |> handle_markdown
  end

  def route(%Conv{path: path} = conv) do
    conv = %{conv | status: 404, res_body: "#{path}: No thing found"}
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}\r
    #{format_response_headers(conv)}
    \r
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

  defp put_content_length(conv) do
    content_length = String.length(conv.res_body)
    new_headers = Map.put(conv.res_headers, "Content-Length", content_length)
    %{conv | res_headers: new_headers }
  end

  defp format_response_headers(conv) do
    for {k,v} <- conv.res_headers do
      "#{k}: #{v}\r"
    end |> Enum.join("\n")
  end
end

request = """
GET /wildthings HTTP/1.1\r
User-Agent: ExampleBrowser/1.0\r
Accept: */*\r
\r
"""

request2 = """
GET /bigfoot HTTP/1.1\r
Host: example.com\r
User-Agent: ExampleBrowser/1.0\r
Accept: */*\r
\r
"""

request3 = """
GET /bears/1 HTTP/1.1\r
Host: example.com\r
User-Agent: ExampleBrowser/1.0\r
Accept: */*\r
\r
"""

request4 = """
DELETE /bears/1 HTTP/1.1\r
Host: example.com\r
User-Agent: ExampleBrowser/1.0\r
Accept: */*\r
\r
"""

request5 = """
GET /wildlife HTTP/1.1\r
Host: example.com\r
User-Agent: ExampleBrowser/1.0\r
Accept: */*\r
\r
"""

request6 = """
GET /bears?id=1 HTTP/1.1\r
Host: example.com\r
User-Agent: ExampleBrowser/1.0\r
Accept: */*\r
\r
"""

request7 = """
GET /about HTTP/1.1\r
Host: example.com\r
User-Agent: ExampleBrowser/1.0\r
Accept: */*\r
\r
"""

request8 = """
GET /bears/new HTTP/1.1\r
Host: example.com\r
User-Agent: ExampleBrowser/1.0\r
Accept: */*\r
\r
"""

request9 = """
POST /bears HTTP/1.1\r
Host: example.com\r
User-Agent: ExampleBrowser/1.0\r
Accept: */*\r
Content-Type: application/x-www-form-urlencoded\r
Content-Length: 21\r
\r
name=Baloo&type=Brown\r
"""

request10 = """
GET /bears HTTP/1.1\r
Host: example.com\r
User-Agent: ExampleBrowser/1.0\r
Accept: */*\r
\r
"""

request11 = """
GET /api/bears HTTP/1.1\r
Host: example.com\r
User-Agent: ExampleBrowser/1.0\r
Accept: */*\r
\r
"""

request12 = """
POST /api/bears HTTP/1.1\r
Host: example.com\r
User-Agent: ExampleBrowser/1.0\r
Accept: */*\r
Content-Type: application/json\r
Content-Length: 21\r
\r
{"name": "Breezly", "type": "Polar"}
"""

request13 = """
GET /faq HTTP/1.1\r
Host: example.com\r
User-Agent: ExampleBrowser/1.0\r
Accept: */*\r
\r
"""
#
# response = Servy.Handler.handle(request)
# IO.puts response
# #
# # IO.inspect elem(Servy.Handler.all_bears(), 0)
#
response = Servy.Handler.handle(request13)
IO.puts response
