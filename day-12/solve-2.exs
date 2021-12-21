defmodule Solve do
  def find_routes(graph, start_node, end_node), do: find_routes(graph, start_node, end_node, [[]])

  def add_node(graph, {a, b}) do
    add_node(add_node(graph, a, b), b, a)
  end

  # private

  def find_routes(_, current, target, paths) when current == target do
    Enum.map(paths, fn path -> [current | path] end)
  end

  def find_routes(graph, current, target, paths) do
    paths = Enum.map(paths, fn path -> [current | path] end)
    reachable_nodes = Map.fetch!(graph, current)
      |> Enum.reject(fn node -> node == "start" end)
      |> Enum.reject(fn node ->
        Enum.count(Enum.frequencies([node | hd(paths)]), fn {n, c} -> String.match?(n, ~r/[^A-Z]/) && c > 2 end) > 0
        || Enum.count(Enum.frequencies([node | hd(paths)]), fn {n, c} -> String.match?(n, ~r/[^A-Z]/) && c > 1 end) > 1
      end)
    Enum.concat(Enum.map(reachable_nodes, fn node -> find_routes(graph, node, target, paths) end))
  end

  def add_node(graph, a, b) do
    Map.update(graph, a, MapSet.new([b]), fn nodes -> MapSet.put(nodes, b) end)
  end
end

{[input: raw_input], _, _} = OptionParser.parse(System.argv(), strict: [input: :string])

graph = File.stream!(raw_input)
  |> Stream.map(&String.trim/1)
  |> Stream.map(&(String.split(&1, "-", trim: true)))
  |> Enum.reduce(%{}, fn [a, b], graph -> Solve.add_node(graph, {a, b}) end)

IO.inspect(graph)

routes = Solve.find_routes(graph, "start", "end")

IO.inspect(routes)
IO.inspect(routes |> Enum.count())
