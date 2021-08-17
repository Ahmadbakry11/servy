defmodule Servy.View do
  @templates_path Path.expand("../templates", __DIR__)

  def render(conv, template, binding_list \\ []) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(binding_list)

    conv = %{ conv | status: 200, res_body: content }
  end
end
