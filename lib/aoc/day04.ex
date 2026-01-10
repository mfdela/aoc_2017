defmodule Aoc.Day04 do
  def part1(args) do
    args
    |> parse()
    |> Enum.filter(&is_valid?/1)
    |> Enum.count()
  end

  def part2(args) do
    args
    |> parse()
    |> Enum.filter(&is_valid_anagram?/1)
    |> Enum.count()
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " ", trim: true))
  end

  def is_valid?(words) do
    Enum.uniq(words) |> Enum.count() == Enum.count(words)
  end

  def is_valid_anagram?(words) do
    sort_letters =
      words |> Enum.map(&String.graphemes/1) |> Enum.map(&Enum.sort/1) |> Enum.map(&Enum.join/1)

    Enum.uniq(sort_letters) |> Enum.count() == Enum.count(sort_letters)
  end
end
