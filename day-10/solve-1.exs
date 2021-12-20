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

score = result |> Stream.filter(fn
  {:corrupted, _, _} -> true
  _ -> false
end) |> Stream.map(fn {_, _, char} -> char end) |> Stream.map(fn
  ")" -> 3
  "]" -> 57
  "}" -> 1197
  ">" -> 25137
end) |> Enum.sum()

IO.inspect(score)
