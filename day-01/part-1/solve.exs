{[input: input], _, _} = OptionParser.parse(System.argv(), strict: [input: :string])

answer = File.stream!(input)
  |> Stream.map(&String.trim/1)
  |> Stream.map(&String.to_integer/1)
  |> Stream.scan([larger: false, last_result: nil], &([larger: &1 > &2[:last_result], last_result: &1]))
  |> Enum.to_list
  |> Enum.count(&(&1[:larger]))

IO.inspect(answer)

