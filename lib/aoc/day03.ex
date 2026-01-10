defmodule Aoc.Day03 do
  def part1(args) do
    args
    |> position()
    |> IO.inspect()
    |> distance({0, 0})
  end

  def part2(args) do
    # Start with square 1 at position {0, 0} with value 1
    grid = %{{0, 0} => 1}
    find_first_larger(2, grid, args)
  end

  def position(1), do: {0, 0}

  def position(n) when n > 1 do
    # Find which "ring" or "layer" the number is in
    # Ring 0: just 1
    # Ring 1: 2-9 (8 numbers)
    # Ring 2: 10-25 (16 numbers)
    # Ring k: (2k-1)^2 + 1 to (2k+1)^2 numbers

    ring = ceil((:math.sqrt(n) - 1) / 2)

    # The last number of the previous ring
    prev_ring_max = (2 * ring - 1) * (2 * ring - 1)

    # Position within current ring (0-indexed)
    offset = n - prev_ring_max - 1

    # Side length of current ring
    side_length = 2 * ring

    # Determine which side and position on that side
    side = div(offset, side_length)
    pos_on_side = rem(offset, side_length)

    case side do
      # Right side, moving up
      0 ->
        {ring, -ring + 1 + pos_on_side}

      # Top side, moving left
      1 ->
        {ring - 1 - pos_on_side, ring}

      # Left side, moving down
      2 ->
        {-ring, ring - 1 - pos_on_side}

      # Bottom side, moving right
      3 ->
        {-ring + 1 + pos_on_side, -ring}
    end
  end

  def distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  defp find_first_larger(n, grid, target) do
    pos = position(n)
    value = sum_adjacent(pos, grid)

    if value > target do
      value
    else
      find_first_larger(n + 1, Map.put(grid, pos, value), target)
    end
  end

  defp sum_adjacent({x, y}, grid) do
    # Get all 8 adjacent positions (including diagonals)
    adjacent_positions = [
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1}
    ]

    adjacent_positions
    |> Enum.map(fn pos -> Map.get(grid, pos, 0) end)
    |> Enum.sum()
  end
end
