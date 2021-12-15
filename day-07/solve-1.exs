{[input: raw_input], _, _} = OptionParser.parse(System.argv(), strict: [input: :string])

positions = File.stream!(raw_input)
  |> Stream.map(&String.trim/1)
  |> Stream.flat_map(&(String.split(&1, ",")))
  |> Stream.map(&String.to_integer/1)
  |> Enum.sort()

min = List.first(positions)
max = List.last(positions)

options = min..max |> Enum.map(fn position ->
  {position, positions |> Enum.map(&(abs(&1 - position))) |> Enum.sum()}
end)

IO.inspect(options)

IO.inspect(options |> Enum.min_by(fn option ->
  {_position, fuel} = option
  fuel
end))
