defmodule Aoc.Day11 do
  def part1(args) do
    args
    |> parse()
    |> path_with_max_distance()
    |> elem(0)
    |> distance()
  end

  def part2(args) do
    args
    |> parse()
    |> path_with_max_distance()
    |> elem(1)
  end

  def parse(input) do
    input
    |> String.trim()
    |> String.split(",", trim: true)
  end

  def move(direction, {x, y}) do
    # Doubled coordinates
    # https://www.redblobgames.com/grids/hexagons/
    case direction do
      "n" -> {x, y - 2}
      "ne" -> {x + 1, y - 1}
      "se" -> {x + 1, y + 1}
      "s" -> {x, y + 2}
      "sw" -> {x - 1, y + 1}
      "nw" -> {x - 1, y - 1}
    end
  end

  def distance({x, y}) do
    abs(x) + max(0, div(abs(y) - abs(x), 2))
  end

  def path_with_max_distance(input) do
    Enum.reduce(input, {{0, 0}, 0}, fn dir, {pos, max_distance} ->
      next_pos = move(dir, pos)
      distance = distance(next_pos)
      {next_pos, max(max_distance, distance)}
    end)
  end
end
