defmodule Solve do
  use Agent

  def start do
    Agent.start_link(fn -> MapSet.new() end, name: __MODULE__)
  end

  def walk(heightmap, {{x, y}, height}) do
    cond do
      height == 9 ->
        []
      visited?({x, y}) ->
        []
      true ->
        visit({x, y})

        neighbours = [{x, y + 1}, {x, y - 1}, {x - 1, y}, {x + 1, y}] 
          |> Enum.filter(&(Map.has_key?(heightmap, &1))) 
          |> Enum.map(&({&1, Map.fetch!(heightmap, &1)}))
          |> Enum.reject(fn {{x, y}, _} -> visited?({x, y}) end)
          |> Enum.reject(fn {_, height} -> height == 9 end)

        Enum.concat([height], Enum.flat_map(neighbours, &(walk(heightmap, &1))))
    end
  end

  def visit(point) do
    Agent.update(__MODULE__, &(MapSet.put(&1, point)))
  end

  def visited?(point) do
    Agent.get(__MODULE__, &(MapSet.member?(&1, point)))
  end
end

{[input: raw_input], _, _} = OptionParser.parse(System.argv(), strict: [input: :string])

Solve.start()

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
end)

basins = Enum.map(lowpoints, fn lowpoint ->
  basin = Solve.walk(heightmap, lowpoint)
  {lowpoint, Enum.count(basin), basin}
end)

IO.inspect(basins)

solution = basins 
  |> Enum.map(fn {_, count, _} -> count end) 
  |> Enum.sort() 
  |> Enum.reverse() 
  |> Enum.take(3) 
  |> Enum.product()

IO.inspect(solution)