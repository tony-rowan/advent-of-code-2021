defmodule Solve do
  def expand(line) do
    case line do
      [x1: x, x2: x, y1: y1, y2: y2] ->
        (y1..y2) |> Enum.map(&(%{x: x, y: &1}))
      [x1: x1, x2: x2, y1: y, y2: y] ->
        (x1..x2) |> Enum.map(&(%{x: &1, y: y}))
    end
  end
end

{[input: raw_input], _, _} = OptionParser.parse(System.argv(), strict: [input: :string])

lines = File.stream!(raw_input)
  |> Stream.map(&String.trim/1)
  |> Stream.map(&(Regex.named_captures(~r/(?<x1>\d+),(?<y1>\d+) -> (?<x2>\d+),(?<y2>\d+)/, &1)))
  |> Stream.map(&(Enum.map(&1, fn {k, v} -> {String.to_atom(k), String.to_integer(v)} end)))
  |> Stream.filter(&(&1[:x1] == &1[:x2] || &1[:y1] == &1[:y2]))

score = lines
  |> Stream.flat_map(&Solve.expand/1)
  |> Stream.map(&("#{&1[:x]},#{&1[:y]}"))
  |> Enum.frequencies
  |> Enum.filter(fn {_k, v} -> v >= 2 end)
  |> Enum.count

IO.inspect(score)

