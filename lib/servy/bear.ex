defmodule Servy.Bear do
  alias Servy.Wildthings

  defstruct [
    id: nil,
    name: "",
    type: "",
    hibernating: false
  ]

  def is_grizzly(bear) do
    bear.type == "Grizzly"
  end

  def sort_asc_name(a,b) do
    a.name <= b.name
  end

  def get_bear(id) when is_integer(id) do
    Wildthings.all_bears()
    |> Enum.find(fn(bear) -> bear.id == id end )
  end

  def get_bear(id) when is_binary(id) do
    String.to_integer(id) |> get_bear
  end
end
