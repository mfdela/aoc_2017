defmodule Aoc.Day17 do
  def part1(args) do
    {curr_pos, buffer} =
      args
      |> parse()
      |> insert(2018)

    Enum.at(buffer, curr_pos + 1)
  end

  def part2(args) do
    # for part 2 we don't need to keep track of the buffer
    # just if the new value is inserted in position 1 (after the 0)
    args
    |> parse()
    |> check_insert(50_000_000)
  end

  def parse(input) do
    input
    |> String.trim()
    |> String.to_integer()
  end

  def insert(steps, stop) do
    insert([0], steps, 0, 1, stop)
  end

  def insert(buffer, _steps, curr_pos, n, stop) when n == stop do
    {curr_pos, buffer}
  end

  def insert(buffer, steps, curr_pos, n, stop) do
    size = length(buffer)
    new_pos = rem(curr_pos + steps, size) + 1

    buffer
    |> List.insert_at(new_pos, n)
    |> IO.inspect(label: "Buffer after insertion #{n}")
    |> insert(steps, new_pos, n + 1, stop)
  end

  def check_insert(steps, stop), do: check_insert(steps, 0, 1, 0, stop)

  def check_insert(_steps, _curr_pos, n, after_zero, stop) when n == stop, do: after_zero

  def check_insert(steps, curr_pos, n, after_zero, stop) do
    size = n
    new_pos = rem(curr_pos + steps, size) + 1
    new_after_zero = if new_pos == 1, do: n, else: after_zero
    check_insert(steps, new_pos, n + 1, new_after_zero, stop)
  end
end
