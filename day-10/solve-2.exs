defmodule Solve do
  def check_syntax(chunk), do: check_syntax(chunk, [])

  def check_syntax([], []), do: {:ok}

  def check_syntax([], stack), do: {:incomplete, stack}

  def check_syntax([chunk_head | chunk_tail], []) do
    if open?(chunk_head) do
      check_syntax(chunk_tail, [chunk_head])
    else
      {:bad_start, chunk_head}
    end
  end

  def check_syntax([chunk_head | chunk_tail], [stack_head | stack_tail]) do
    if open?(chunk_head) do
      check_syntax(chunk_tail, [chunk_head | [stack_head | stack_tail]])
    else
      if matching?(chunk_head, stack_head) do
        check_syntax(chunk_tail, stack_tail)
      else
        {:corrupted, stack_head, chunk_head}
      end
    end
  end

  def open?(char), do: char == "(" || char == "[" || char == "{" || char == "<"

  def matching?(close, open) when open == "(", do: close == ")"
  def matching?(close, open) when open == "[", do: close == "]"
  def matching?(close, open) when open == "{", do: close == "}"
  def matching?(close, open) when open == "<", do: close == ">"
end

{[input: raw_input], _, _} = OptionParser.parse(System.argv(), strict: [input: :string])

result = File.stream!(raw_input)
  |> Stream.map(&String.trim/1)
  |> Stream.map(&(String.split(&1, "", trim: true)))
  |> Stream.map(&Solve.check_syntax/1)

IO.inspect(result |> Enum.to_list)

scores = result |> Stream.filter(fn
  {:incomplete, _} -> true
  _ -> false
end) |> Stream.map(fn {_, stack} -> stack end) |> Stream.map(&(Enum.map(&1, fn
  "(" -> 1
  "[" -> 2
  "{" -> 3
  "<" -> 4
end))) |> Stream.map(&(Enum.reduce(&1, 0, fn x, acc ->
  acc * 5 + x
end))) |> Enum.to_list()

IO.inspect(scores)

sorted_scores = scores |> Enum.sort
index = scores |> length() |> div(2)

IO.inspect(Enum.at(sorted_scores, index))
