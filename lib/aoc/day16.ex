defmodule Aoc.Day16 do
  def part1(args, string \\ "abcdefghijklmnop") do
    list = string |> String.graphemes()

    args
    |> parse()
    |> apply_instructions(list)
    |> Enum.join()
  end

  def part2(args, string \\ "abcdefghijklmnop") do
    instructions = args |> parse()
    list = string |> String.graphemes()
    {cycle_count, seen, last_seen} = find_cycle(instructions, list)


    if last_seen == list do
      # the cycle start from the first element again
      remainder = rem(1_000_000_000, cycle_count)
      Enum.find(seen, &(elem(&1, 1) == remainder))
      |> elem(0)
      |> Enum.join()
    else
      IO.puts("Not implemented")
    end
  end

  def parse(input) do
    input
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&parse_instruction/1)
  end

  def parse_instruction("s" <> rest) do
    {:spin, String.to_integer(rest)}
  end

  def parse_instruction("x" <> rest) do
    [a, b] = String.split(rest, "/")
    {:exchange, String.to_integer(a), String.to_integer(b)}
  end

  def parse_instruction("p" <> rest) do
    [a, b] = String.split(rest, "/")
    {:partner, a, b}
  end

  def apply_instruction({:spin, n}, list) do
    {head, tail} = Enum.split(list, -n)
    tail ++ head
  end

  def apply_instruction({:exchange, n, m}, list) do
    val_1 = Enum.at(list, n)
    val_2 = Enum.at(list, m)

    list
    |> List.update_at(n, fn _ -> val_2 end)
    |> List.update_at(m, fn _ -> val_1 end)
  end

  def apply_instruction({:partner, a, b}, list) do
    index_a = Enum.find_index(list, &(&1 == a))
    index_b = Enum.find_index(list, &(&1 == b))

    list
    |> List.update_at(index_a, fn _ -> b end)
    |> List.update_at(index_b, fn _ -> a end)
  end

  def apply_instructions(instructions, list) do
    Enum.reduce(instructions, list, &apply_instruction/2)
  end

  def find_cycle(instructions, list) do
    init_seen_list = Map.new([{list, 1}])

    Enum.reduce_while(1..1_000_000_000, {list, init_seen_list}, fn i, {start_list, seen} ->
      new_list = apply_instructions(instructions, start_list)

      if Map.has_key?(seen, new_list) do
        {:halt, {i, seen, new_list}}
      else
        {:cont, {new_list, Map.put(seen, new_list, i)}}
      end
    end)
  end
end
