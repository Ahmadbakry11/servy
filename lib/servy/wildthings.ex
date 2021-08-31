defmodule Servy.Wildthings do
  # @db_path Path.expand("../db", __DIR__)
  alias Servy.Bear

  defp read_json do
    Path.expand("../db", __DIR__)
    |> Path.join("bears.json")
    |> File.read()
    |> handle_file
  end

  defp handle_file({:ok, content}) do
    Poison.decode!(content, as: %{"bears" => [%Bear{}]})
    |> Map.get("bears")
  end

  defp handle_file({:error, reason}) do
    IO.inspect "There is an error: #{reason}"
    [""]
  end

  def all_bears() do
    read_json()
  end
end
