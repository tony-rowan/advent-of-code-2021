defmodule Solve do
  def visualize(paper) do
    {max_x, _} = paper |> Enum.max_by(fn {x, _} -> x end)
    {_, max_y} = paper |> Enum.max_by(fn {_, y} -> y end)

    Enum.map(0..max_y, fn y ->
      Enum.map(0..max_x, fn x ->
        if Enum.member?(paper, {x, y}) do
          "#"
        else
          "."
        end
      end) |> Enum.reduce(&(&2 <> &1))
    end) |> Enum.reduce(&(&2 <> "\n" <> &1))
  end
end

{[input: raw_input], _, _} = OptionParser.parse(System.argv(), strict: [input: :string])

[paper, instructions] = File.stream!(raw_input)
  |> Stream.map(&String.trim/1)
  |> Stream.reject(&(&1 == ""))
  |> Stream.chunk_by(&(String.match?(&1, ~r/\d+,\d+/)))
  |> Enum.to_list()

paper = paper
  |> Enum.map(fn dot_string -> dot_string |> String.split(",") |> Enum.map(fn x -> String.to_integer(x) end) end)
  |> Enum.map(fn [x | [y]] -> {x, y} end)
  |> MapSet.new()

instructions = instructions
  |> Enum.map(fn instruction ->
    %{"dimension" => dimension, "value" => value} = Regex.named_captures(~r/fold along (?<dimension>[a-z])=(?<value>\d+)/, instruction)
    {dimension, String.to_integer(value)}
  end)

paper = instructions |> Enum.reduce(paper, fn {fold_line, fold_value}, paper ->
  paper |> Enum.map(fn {x, y} ->
    if fold_line == "y" do
      if y > fold_value do
        diff = y - fold_value
        {x, fold_value - diff}
      else
        {x, y}
      end
    else
      if x > fold_value do
        diff = x - fold_value
        {fold_value - diff, y}
      else
        {x, y}
      end
    end
  end) |> MapSet.new()
end)

IO.puts(paper |> Solve.visualize())
