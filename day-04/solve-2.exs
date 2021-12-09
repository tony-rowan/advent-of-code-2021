defmodule Solve do  
  def play_game([], _) do
    raise "Abort, infinite recursion"
  end
  
  def play_game(numbers, boards) do
    [number | rest] = numbers

    new_boards = boards 
      |> Enum.map(&(Enum.map(&1, fn row -> Enum.map(row, fn marked_number -> %{number: marked_number[:number], marked: marked_number[:marked] || marked_number[:number] == number} end) end)))
    
    {completed_boards, yet_to_be_completed_boards} = Enum.split_with(new_boards, &board_marked?/1)

    if Enum.count(completed_boards) == 1 && Enum.count(yet_to_be_completed_boards) == 0 do
      [number: number, board: hd(completed_boards)]
    else
      play_game(rest, yet_to_be_completed_boards)
    end
  end

  def board_marked?(board) do
    Enum.any?(board, &line_marked?/1) || Enum.any?(board |> to_columns, &line_marked?/1)
  end

  def line_marked?(line) do
    Enum.all?(line, fn number -> number[:marked] end)
  end

  def to_columns(board) do
    rows = board |> Enum.map(&List.to_tuple/1) |> List.to_tuple()
    for n <- 0..4, do: for m <- 0..4, do: elem(elem(rows, m), n)
  end
end

{[input: input], _, _} = OptionParser.parse(System.argv(), strict: [input: :string])

[numbers_input | boards_input] = File.stream!(input) |> Stream.map(&String.trim/1) |> Enum.to_list()

numbers = numbers_input |> String.split(",")

boards = boards_input 
  |> Enum.drop(1) 
  |> Enum.chunk_every(5, 6) 
  |> Enum.map(&(Enum.map(&1, fn row -> String.split(row) end)))
  |> Enum.map(&(Enum.map(&1, fn row -> Enum.map(row, fn number -> %{number: number, marked: false} end) end)))

[number: number, board: completed_board] = Solve.play_game(numbers, boards)

number_int = number |> String.to_integer()
unmarked_numbers_sum = completed_board 
  |> Enum.to_list() 
  |> List.flatten() 
  |> Enum.filter(&(!&1[:marked]))
  |> Enum.map(&(&1[:number]))
  |> Enum.map(&String.to_integer/1)
  |> Enum.sum()

IO.inspect([number_int, unmarked_numbers_sum])
IO.inspect(number_int * unmarked_numbers_sum)
