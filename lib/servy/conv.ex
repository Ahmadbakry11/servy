defmodule Servy.Conv do
  defstruct [
    method: "",
    status: nil,
    res_body: "",
    path: "",
    params: %{},
    headers: %{}
  ]
end
