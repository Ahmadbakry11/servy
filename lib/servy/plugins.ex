defmodule Servy.Plugins do
  alias Servy.Conv

  def rewrite(%Conv{path: "/bears?id="<>id} = conv) do
    %{conv | path: "/bears/#{id}"}
  end

  def rewrite(%Conv{} = conv), do: conv

  def redirect(%Conv{method: "GET", path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def redirect(%Conv{} = conv), do: conv

  def log(%Conv{} = conv) do
    if Mix.env == :dev do
      IO.inspect(conv)
    end
    conv
  end

  def track(%Conv{status: 404} = conv) do
    if Mix.env != :test do
      IO.inspect(conv)
    end
    conv
  end

  def track(conv), do: conv

  def emojify(%{status: 200} = conv) do
    %{conv | res_body: "(:) #{conv.res_body} (:)"}
  end

  def emojify(conv), do: conv
end
