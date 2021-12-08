defmodule Solve do
  def generate_bit_counts(readings) do
    readings
      |> Enum.map(&(Enum.map(&1, fn (bit) -> if bit == "1", do: 1, else: -1 end)))
      |> Enum.reduce(&Enum.zip_with([&1, &2], fn [x, y] -> x + y end))
      |> List.to_tuple
  end

  def filter_to_oxygen_readings([], _index) do
    raise "Abort"
  end

  def filter_to_oxygen_readings([reading], _index) do
    reading
  end

  def filter_to_oxygen_readings(readings, index) do
    bit_counts = readings |> generate_bit_counts()

    readings
      |> Enum.map(&List.to_tuple/1)
      |> Enum.filter(fn reading -> if elem(bit_counts, index) >= 0, do: elem(reading, index) == "1", else: elem(reading, index) == "0" end)
      |> Enum.map(&Tuple.to_list/1)
      |> filter_to_oxygen_readings(index + 1)
  end

  def filter_to_carbon_readings([], _index) do
    raise "Abort"
  end

  def filter_to_carbon_readings([reading], _index) do
    reading
  end

  def filter_to_carbon_readings(readings, index) do
    bit_counts = readings |> generate_bit_counts()

    readings
      |> Enum.map(&List.to_tuple/1)
      |> Enum.filter(fn reading -> if elem(bit_counts, index) < 0, do: elem(reading, index) == "1", else: elem(reading, index) == "0" end)
      |> Enum.map(&Tuple.to_list/1)
      |> filter_to_carbon_readings(index + 1)
  end
end

{[input: input], _, _} = OptionParser.parse(System.argv(), strict: [input: :string])

readings = File.stream!(input)
  |> Stream.map(&String.trim/1)
  |> Stream.map(&String.split(&1, "", trim: true))

oxygen_rating = readings
  |> Solve.filter_to_oxygen_readings(0)
  |> Enum.join()
  |> String.to_integer(2)

carbon_scrubber_rating = readings
  |> Solve.filter_to_carbon_readings(0)
  |> Enum.join()
  |> String.to_integer(2)

IO.inspect(oxygen_rating)
IO.inspect(carbon_scrubber_rating)
IO.inspect(oxygen_rating * carbon_scrubber_rating)
