defmodule Solve do
  def solve(line) do
    [signal_patterns | [output_values]] = line

    patterns = signal_patterns |> Enum.map(&(MapSet.new(String.split(&1, "", trim: true))))
    values = output_values |> Enum.map(&(MapSet.new(String.split(&1, "", trim: true))))

    digit_1 = Enum.find(patterns, &(MapSet.size(&1) == 2))
    digit_4 = Enum.find(patterns, &(MapSet.size(&1) == 4))
    digit_7 = Enum.find(patterns, &(MapSet.size(&1) == 3))
    digit_8 = Enum.find(patterns, &(MapSet.size(&1) == 7))

    digit_3 = Enum.find(patterns, &(MapSet.size(&1) == 5 && MapSet.subset?(digit_1, &1)))
    digit_9 = Enum.find(patterns, &(MapSet.size(&1) == 6 && MapSet.subset?(digit_3, &1)))
    digit_0 = Enum.find(patterns, &(MapSet.size(&1) == 6 && MapSet.subset?(digit_7, &1) && !MapSet.equal?(digit_9, &1)))
    digit_6 = Enum.find(patterns, &(MapSet.size(&1) == 6 && !MapSet.equal?(digit_9, &1) && !MapSet.equal?(digit_0, &1)))
    digit_5 = Enum.find(patterns, &(MapSet.size(&1) == 5 && MapSet.subset?(&1, digit_6)))
    digit_2 = Enum.find(patterns, &(MapSet.size(&1) == 5 && !MapSet.equal?(digit_3, &1) && !MapSet.equal?(digit_5, &1)))

    digits = [
      {"0", digit_0}, 
      {"1", digit_1}, 
      {"2", digit_2}, 
      {"3", digit_3}, 
      {"4", digit_4}, 
      {"5", digit_5}, 
      {"6", digit_6}, 
      {"7", digit_7}, 
      {"8", digit_8}, 
      {"9", digit_9}
    ]

    values 
      |> Enum.map(&(Enum.find(digits, fn {_, digit} -> MapSet.equal?(digit, &1) end))) 
      |> Enum.map(fn {value, _} -> value end)
      |> List.to_string()
      |> String.to_integer()
  end
end

{[input: raw_input], _, _} = OptionParser.parse(System.argv(), strict: [input: :string])

solution = File.stream!(raw_input)
  |> Stream.map(&String.trim/1)
  |> Stream.map(&(String.split(&1, "|", trim: true)))
  |> Stream.map(&(Enum.map(&1, fn s -> String.split(s, " ", trim: true) end)))
  |> Stream.map(&Solve.solve/1)
  |> Enum.sum()

IO.inspect(solution)
