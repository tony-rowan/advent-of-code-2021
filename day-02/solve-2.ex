parse_instruction = fn (instruction) ->
  [word, value] = String.split(instruction)
  %{word: word, value: String.to_integer(value)}
end

reduce_instruction = fn (ins, acc) ->
  case ins do
    %{word: "forward", value: value} -> 
      [horizontal: acc[:horizontal] + value, depth: acc[:depth] + acc[:aim] * value, aim: acc[:aim]]
    %{word: "up", value: value} ->
      [horizontal: acc[:horizontal], depth: acc[:depth], aim: acc[:aim] - value]
    %{word: "down", value: value} ->
      [horizontal: acc[:horizontal], depth: acc[:depth], aim: acc[:aim] + value]
  end
end

{[input: input], _, _} = OptionParser.parse(System.argv(), strict: [input: :string])

answer = File.stream!(input)
  |> Stream.map(&String.trim/1)
  |> Stream.map(parse_instruction)
  |> Enum.reduce([horizontal: 0, depth: 0, aim: 0], reduce_instruction)

IO.inspect(answer)
IO.inspect(answer[:horizontal] * answer[:depth])