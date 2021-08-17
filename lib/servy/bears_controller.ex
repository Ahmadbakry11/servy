defmodule Servy.BearsController do
  alias Servy.Wildthings
  alias Servy.Bear
  alias Servy.View



  # defp bear_item(bear) do
  #   "<li>Bear: #{bear.id} with name: #{bear.name}</li>"
  # end



  def index(conv) do
    bears = Wildthings.all_bears()
    # |> Enum.filter(&Bear.is_grizzly/1)
    |> Enum.sort(&Bear.sort_asc_name/2)

    View.render(conv, "index.eex", [bears: bears])
    # |> Enum.map(&bear_item/1)
    # |> Enum.join

  end

  def show(conv, %{"id" => id}) do
    bear = Bear.get_bear(id)
    View.render(conv, "show.eex", [bear: bear])
  end

  def create(conv, %{"type" => type, "name" => name}) do
    conv = %{ conv | status: 201, res_body: "Bear created with type: #{type} and name: #{name}"}
  end

  def delete(conv, %{"id" => id}) do
    conv = %{ conv | status: 403, res_body: "Deleting bear: #{id} is forbidden"}
  end
end
