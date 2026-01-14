defmodule Aoc.Day13 do
  def part1(args) do
    args
    |> parse()
    |> packet()
  end

  def part2(args) do
    args
    |> parse()
    |> traverse()
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.map(fn [depth, range] -> {String.to_integer(depth), String.to_integer(range)} end)
    |> Map.new()
  end

  def scanner(layers, time) do
    # position at time `time`
    Enum.reduce(layers, %{}, fn {depth, range}, acc ->
      position = range - abs(rem(time, 2 * range - 2) - (range - 1)) - 1

      Map.put(acc, depth, position)
    end)
  end

  def packet(layers) do
    size = layers |> Map.keys() |> Enum.max()

    for t <- 0..size, reduce: 0 do
      acc ->
        IO.puts("Time #{t}")
        scanners = scanner(layers, t) |> IO.inspect()

        case layers[t] do
          nil -> acc
          val -> if scanners[t] == 0, do: acc + val * t, else: acc
        end
    end
  end

  # packet arrives at depth d at time d + delay
  # scanner period is 2 * range - 2
  # scanner is at position 0 if (d + delay) mod (2 * r - 2) == 0
  # need to find the smallest delay such that for all layers
  #  (d + delay) mod (2 * r - 2) != 0
  #  if they were equalities, we could use the Chinese remainder theorem
  # we try brute force

  def traverse(layers) do
    Stream.iterate(0, &(&1 + 1))
    |> Enum.find(fn delay ->
      not_caught?(layers, delay)
    end)
  end

  def not_caught?(layers, delay) do
    Enum.all?(layers, fn {depth, range} ->
      rem(depth + delay, 2 * range - 2) != 0
    end)
  end
end
