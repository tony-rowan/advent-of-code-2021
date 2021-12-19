{[input: raw_input], _, _} = OptionParser.parse(System.argv(), strict: [input: :string])

heightmap = File.stream!(raw_input)
  |> Stream.map(&String.trim/1)
  |> Stream.map(&(String.split(&1, "", trim: true)))
  |> Stream.map(&(Enum.map(&1, fn height -> String.to_integer(height) end)))
  |> Stream.map(&(Enum.with_index(&1, fn height, x -> {x, height} end)))
  |> Enum.with_index(fn heights, y -> Enum.map(heights, fn {x, height} -> {{x, y}, height} end) end)
  |> Enum.concat()
  |> Enum.reduce(%{}, fn {coord, height}, acc -> Map.put(acc, coord, height) end)

lowpoints = Enum.filter(heightmap, fn {{x, y}, height} ->
  adjacent = [{x, y + 1}, {x, y - 1}, {x - 1, y}, {x + 1, y}]
  Enum.all?(adjacent, &(height < Map.get(heightmap, &1, 10)))
end) |> Enum.map(fn {_, height} -> height end)

IO.inspect(lowpoints)

risk = lowpoints |> Enum.map(&(&1 + 1)) |> Enum.sum()

IO.inspect(risk)
