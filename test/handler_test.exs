defmodule HandlerTest do
  use ExUnit.Case
  doctest Servy.Handler

  # alias Servy.Handler
  import Servy.Handler, only: [handle: 1]

  test "Handling the http request" do
    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response ==
      """
      HTTP/1.1 200 Ok\r
      Content-Type: text/html\r
      Content-Length: 28\r
      \r
      (:) Bears, Lions, Tigers (:)
      """
  end

  test "getting a list of bears rendered" do
    request = """
    GET /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """
    response = handle(request)
    expected_response =
    """
    HTTP/1.1 200 Ok\r
    Content-Type: text/html\r
    Content-Length: 509\r
    \r
    (:) <h1>Bears List</h1>
      <ul>
        <li>Bear: Brutus with type: Grizzly</li>
        <li>Bear: Iceman with type: Polar</li>
        <li>Bear: Kenai with type: Grizzly</li>
        <li>Bear: Paddington with type: Brown</li>
        <li>Bear: Roscoe with type: Panda</li>
        <li>Bear: Rosie with type: Black</li>
        <li>Bear: Scarface with type: Grizzly</li>
        <li>Bear: Smokey with type: Black</li>
        <li>Bear: Snow with type: Polar</li>
        <li>Bear: Teddy with type: Brown</li>
      </ul>(:)
    """
    assert clean_space(expected_response) == clean_space(response)
  end

  test "deleting abear from bears list" do
    request = """
    DELETE /bears/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """
    response = handle(request)
    assert response = """
    HTTP/1.1 403 Forbidden\r
    Content-Type: text/html\r
    Content-Length: 29\r
    \r
    Deleting bear: 1 is forbidden
    """
  end

  defp clean_space(text) do
    String.replace(text, ~r/\s/, "")
  end
end
