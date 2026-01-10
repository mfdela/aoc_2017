defmodule Aoc.Day05 do
  def part1(args) do
    args
    |> parse()
    |> jump(0)
  end

  def part2(args) do
    args
    |> parse()
    |> jump2(0)
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.map(fn {value, index} -> {index, value} end)
    |> Map.new()
  end

  def jump(map, index, steps \\ 0) do
    case Map.fetch(map, index) do
      {:ok, value} ->
        map
        |> Map.put(index, value + 1)
        |> jump(index + value, steps + 1)

      :error ->
        steps
    end
  end

  def jump2(map, index, steps \\ 0) do
    case Map.fetch(map, index) do
      {:ok, value} ->
        inc = if value >= 3, do: -1, else: 1

        map
        |> Map.put(index, value + inc)
        |> jump2(index + value, steps + 1)

      :error ->
        steps
    end
  end
end
