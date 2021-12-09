{[input: input], _, _} = OptionParser.parse(System.argv(), strict: [input: :string])

gamma_bits = File.stream!(input)
  |> Stream.map(&String.trim/1)
  |> Stream.map(&String.split(&1, "", trim: true))
  |> Stream.map(&(Enum.map(&1, fn (bit) -> if bit == "1", do: 1, else: -1 end)))
  |> Enum.reduce(&Enum.zip_with([&1, &2], fn [x, y] -> x + y end))
  |> Enum.map(&(if &1 > 0, do: "1", else: "0"))

epsilon = gamma_bits
  |> Enum.map(&(if &1 == "0", do: "1", else: "0"))
  |> Enum.join()
  |> String.to_integer(2)

gamma = gamma_bits
  |> Enum.join()
  |> String.to_integer(2)

IO.inspect([gamma: gamma, epsilon: epsilon])
IO.inspect(gamma * epsilon)

