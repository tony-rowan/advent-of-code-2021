defmodule Solve do
  use Agent

  def start do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def simulate([_], days) when days == 0 do
    1
  end

  def simulate([fish], days) do
    cached_value = memo(fish, days)

    if cached_value do
      cached_value
    else
      value = simulate(fish |> tick(), days - 1)
      memo(fish, days, value)
      value
    end
  end

  def simulate(fish, days) do
    cached_value = memo(fish, days)

    if cached_value do
      cached_value
    else
      [head | tail] = fish
      value = simulate([head], days) + simulate(tail, days)
      memo(fish, days, value)
      value
    end
  end

  def tick(fish) when fish == 0, do: [6, 8]
  def tick(fish), do: [fish - 1]

  def memo(fish, days) do
    Agent.get(__MODULE__, &(Map.get(&1, "#{fish}::#{days}")))
  end

  def memo(fish, days, value) do
    Agent.update(__MODULE__, &(Map.put(&1, "#{fish}::#{days}", value)))
  end
end

{[input: raw_input, days: days], _, _} = OptionParser.parse(System.argv(), strict: [input: :string, days: :integer])

{:ok, _} = Solve.start

solution = File.stream!(raw_input)
  |> Stream.map(&String.trim/1)
  |> Stream.map(&(String.split(&1, ",")))
  |> Enum.flat_map(fn line -> Enum.map(line, &String.to_integer/1) end)
  |> Solve.simulate(days)

IO.inspect(solution)
