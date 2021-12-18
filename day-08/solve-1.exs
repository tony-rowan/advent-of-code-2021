{[input: raw_input], _, _} = OptionParser.parse(System.argv(), strict: [input: :string])

input = File.stream!(raw_input)
  |> Stream.map(&String.trim/1)
  |> Stream.map(&(String.split(&1, "|", trim: true)))
  |> Stream.map(&(Enum.map(&1, fn s -> String.split(s, " ", trim: true) end)))

count = input 
  |> Stream.flat_map(fn [_signal_patterns | [output_values]] -> output_values end)
  |> Stream.map(&String.length/1)
  |> Enum.count(&(&1 == 2 || &1 == 3 || &1 == 4 || &1 == 7))

IO.inspect(count)
