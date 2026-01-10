defmodule Aoc.Day01 do
  def part1(args) do
   string = args
    |> parse_input()

    string
    |> Map.put(Enum.count(string), string[0])
    |> find_consecutives()
  end

  def part2(args) do
    args
    |> parse_input()
    |> find_halfway()
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {char, index} -> {index, String.to_integer(char)} end)
    |> Map.new()
  end

  def find_consecutives(input) do
    input
    |> Map.keys()
    |> Enum.sort()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> if input[a] == input[b], do: input[a], else: 0 end)
    |> Enum.sum()
  end

  def find_halfway(input) do
    size = Enum.count(input)
    input
    |> Enum.reduce(0, fn {index, value}, acc ->
      if value == input[rem(index + div(size, 2), size)], do: acc + value, else: acc
    end)

  end

end
