defmodule Aoc.Day02 do
  def part1(args) do
    args
    |> parse_input()
    |> checksum()
  end

  def part2(args) do
    args
    |> parse_input()
    |> even_division()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ~r/\s+/, trim: true))
    |> Enum.map(fn row -> Enum.map(row, &String.to_integer/1) end)
  end

  def checksum(input) do
    input
    |> Enum.map(fn row -> Enum.max(row) - Enum.min(row) end)
    |> Enum.sum()
  end

  def even_division(input) do
    input
    |> Enum.map(fn row ->
      Enum.find_value(row, fn x ->
        Enum.find_value(row, fn y ->
          if x != y and rem(x, y) == 0 do
            div(x, y)
          end
        end)
      end)
    end)
    |> Enum.sum()
  end
end
