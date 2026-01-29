defmodule Aoc.Day22 do
  def part1(args, iter \\ 10_000) do
    map = parse(args)
    start = find_start(map)
    {start, {-1, 0}, map, 0}
    |> Stream.iterate(&next_move/1)
    |> Enum.at(iter)
    |> elem(3)
  end

  def part2(args, iter \\ 10_000_000) do
    map = parse(args)
    start = find_start(map)
    {start, {-1, 0}, map, 0}
    |> Stream.iterate(&next_move_part2/1)
    |> Enum.at(iter)
    |> elem(3)  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, r}, acc ->
      Enum.with_index(row)
      |> Enum.reduce(acc, fn {cell, c}, acc ->
        state = if cell == "#", do: :infected, else: :clean
        Map.put(acc, {r, c}, state)
      end)
    end)
  end

def find_start(map) do
  # Find the dimensions of the grid
  max_row = map |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.max()
  max_col = map |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.max()
  # The center is at (max_row / 2, max_col / 2)
  {div(max_row, 2), div(max_col, 2)}
end

  def rotate_right(dir) do
    case dir do
      # down -> left
      {1, 0} -> {0, -1}
      # right -> down
      {0, 1} -> {1, 0}
      # up -> right
      {-1, 0} -> {0, 1}
      # left -> up
      {0, -1} -> {-1, 0}
    end
  end

  def rotate_left(dir) do
    case dir do
      # down -> right
      {1, 0} -> {0, 1}
      # right -> up
      {0, 1} -> {-1, 0}
      # up -> left
      {-1, 0} -> {0, -1}
      # left -> down
      {0, -1} -> {1, 0}
    end
  end

  def infect({r, c}, dir, map) do
    case Map.get(map, {r, c}, :clean) do
      :clean -> {rotate_left(dir), :infected}
      :infected -> {rotate_right(dir), :clean}
    end
  end

  def next_move({{r, c}, dir, map, count}) do
   {{dr, dc} = new_dir, new_state} = infect({r, c}, dir, map)
   new_count = if new_state == :infected, do: count + 1, else: count
   {{r + dr, c + dc}, new_dir,  Map.put(map, {r, c}, new_state), new_count}
  end


  def reverse_dir(dir) do
    case dir do
      {dr, dc} -> {-dr, -dc}
    end
  end

  def infect_part2({r, c}, dir, map) do
    state = Map.get(map, {r, c}, :clean)

    new_dir = case state do
      :clean -> rotate_left(dir)      # Turn left
      :weakened -> dir                 # No turn
      :infected -> rotate_right(dir)   # Turn right
      :flagged -> reverse_dir(dir)     # Reverse direction
    end

    new_state = case state do
      :clean -> :weakened
      :weakened -> :infected
      :infected -> :flagged
      :flagged -> :clean
    end

    {new_dir, new_state}
  end

  def next_move_part2({{r, c}, dir, map, count}) do
    {{dr, dc} = new_dir, new_state} = infect_part2({r, c}, dir, map)
    new_count = if new_state == :infected, do: count + 1, else: count
    {{r + dr, c + dc}, new_dir, Map.put(map, {r, c}, new_state), new_count}
  end

end
