defmodule Servy.Conv do
  defstruct [
    method: "",
    status: nil,
    res_body: "",
    path: "",
    res_headers: %{"Content-Type" => "text/html", "Content-Length" => nil},
    params: %{},
    headers: %{}
  ]
end
