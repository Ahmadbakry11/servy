defmodule Servy.Api.BearsController do
  def index(conv) do
    json_response = Servy.Wildthings.all_bears()
    |> Poison.encode!

    conv = set_res_type(conv, "application/json")

    %{conv | status: 200, res_body: json_response}
  end

  defp set_res_type(conv, type) do
    new_res_headers = Map.put(conv.res_headers, "Content-Type", type)
    conv = %{ conv | res_headers: new_res_headers}
  end

  def create(conv, %{"type" => type, "name" => name}) do
    conv = set_res_type(conv, "application/json")
    conv = %{ conv | status: 201, res_body: "Bear created with type: #{type} and name: #{name}"}
  end
end
