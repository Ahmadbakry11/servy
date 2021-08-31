defmodule Servy.FileHandler do
  def handle_file({:ok, content}, conv) do
    conv = %{ conv | status: 200, res_body: content }
  end

  def handle_file({:error, :enoent}, conv) do
    conv = %{ conv | status: 404, res_body: "File not found!" }
  end

  def handle_file({:error, reason}, conv) do
    conv = %{ conv | status: 500, res_body: reason }
  end

  def handle_markdown(conv) do
    case conv.status do
      "200" ->
        %{conv | res_body: Earmark.as_html!(conv.res_body)}
      _ ->
        conv
    end
  end
end
