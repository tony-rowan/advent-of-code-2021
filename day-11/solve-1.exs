defmodule Solve do
  def simulate(_, steps) when steps == 0, do: 0

  def simulate(energymap, steps) do
    energymap = Enum.reduce(energymap, %{}, fn {{x, y}, energy}, map -> Map.put(map, {x, y}, energy + 1) end) |> fan
    Enum.count(energymap, fn {_, energy} -> energy == 0 end) + simulate(energymap, steps - 1)
  end

  def fan(energymap) do    
    energymap = Enum.reduce(energymap, energymap, fn {{x, y}, energy}, map ->
      if energy > 9 do
        Enum.reduce(adjacents(x, y), Map.put(map, {x, y}, 0), fn {x, y}, map ->
          case Map.get(map, {x, y}, -1) do
            -1 -> map
            0 -> Map.put(map, {x, y}, 0)
            _ -> Map.update!(map, {x, y}, fn energy -> energy + 1 end)
          end
        end)
      else
        Map.update!(map, {x, y}, fn energy -> energy end)
      end
    end)

    if Enum.any?(energymap, fn {_, energy} -> energy > 9 end) do
      fan(energymap)
    else
      energymap
    end
  end

  def adjacents(x, y) do
    [
      {x - 1, y - 1},
      {x - 1, y},
      {x - 1, y + 1},
      {x, y - 1},
      {x, y + 1},
      {x + 1, y - 1},
      {x + 1, y},
      {x + 1, y + 1}
    ]
  end
end

{[input: raw_input], _, _} = OptionParser.parse(System.argv(), strict: [input: :string])

input = File.stream!(raw_input)
  |> Stream.map(&String.trim/1)
  |> Stream.map(&(String.split(&1, "", trim: true)))
  |> Stream.map(&(Enum.map(&1, fn energy -> String.to_integer(energy) end)))
  |> Stream.map(&(Enum.with_index(&1, fn energy, x -> {x, energy} end)))
  |> Enum.with_index(fn energies, y -> Enum.map(energies, fn {x, energy} -> {{x, y}, energy} end) end)
  |> Enum.concat()
  |> Enum.reduce(%{}, fn {coord, energy}, acc -> Map.put(acc, coord, energy) end)

IO.inspect(input)

flashes = Solve.simulate(input, 100)

IO.inspect(flashes)