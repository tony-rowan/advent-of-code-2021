defmodule Solve do
  use Agent

  def start do
    Agent.start_link(fn -> %{0 => 0, 1 => 1} end, name: __MODULE__)
  end


  def factorial(n) when n == 0, do: 0

  def factorial(n) do
    cached_value = memo(n)
    if cached_value do
      cached_value
    else
      value = n + factorial(n - 1)
      memo(n, value)
      value
    end
  end

  def memo(n) do
    Agent.get(__MODULE__, &(Map.get(&1, n)))
  end

  def memo(n, value) do
    Agent.update(__MODULE__, &(Map.put(&1, n, value)))
  end
end

{[input: raw_input], _, _} = OptionParser.parse(System.argv(), strict: [input: :string])

Solve.start()

positions = File.stream!(raw_input)
  |> Stream.map(&String.trim/1)
  |> Stream.flat_map(&(String.split(&1, ",")))
  |> Stream.map(&String.to_integer/1)
  |> Enum.sort()

min = List.first(positions)
max = List.last(positions)

options = min..max |> Enum.map(fn position ->
  {position, positions |> Enum.map(&(Solve.factorial(abs(&1 - position)))) |> Enum.sum()}
end)

IO.inspect(options)

IO.inspect(options |> Enum.min_by(fn option ->
  {_position, fuel} = option
  fuel
end))
