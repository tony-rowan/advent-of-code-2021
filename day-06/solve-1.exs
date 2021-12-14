defmodule Solve do
  def simulate(fish, days) when days == 0, do: fish
  def simulate(fish, days), do: fish |> Enum.flat_map(&simulate/1) |> simulate(days - 1)

  def simulate(fish) when fish == 0, do: [6, 8]
  def simulate(fish), do: [fish - 1]
end

{[input: raw_input], _, _} = OptionParser.parse(System.argv(), strict: [input: :string])

solution = File.stream!(raw_input)
  |> Stream.map(&String.trim/1)
  |> Stream.map(&(String.split(&1, ",")))
  |> Enum.flat_map(fn line -> Enum.map(line, &String.to_integer/1) end)
  |> Solve.simulate(80)

IO.inspect(solution |> Enum.count)
