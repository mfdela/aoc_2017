defmodule Aoc.Day14 do
  def part1(args) do
    args
    |> parse()
    |> build_grid()
    |> Enum.map(fn {_, row} -> row |> String.graphemes() |> Enum.count(&(&1 == "1")) end)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> parse()
    |> build_grid()
    |> grid_to_map()
    |> find_regions()
    |> Enum.count()
  end

  def parse(input) do
    input
    |> String.trim()
  end

  def hash(lengths_sequence, list, initial_pos \\ 0, initial_skip \\ 0) do
    size = length(list)

    Enum.reduce(lengths_sequence, {list, initial_pos, initial_skip}, fn length,
                                                                        {list, pos, skip} ->
      {reverse(list, pos, length, size), rem(pos + length + skip, size), skip + 1}
    end)
  end

  def reverse(list, pos, length, size) do
    # Extract elements with wrapping
    indices = Enum.map(0..(length - 1)//1, fn i -> rem(pos + i, size) end)
    elements = Enum.map(indices, fn idx -> Enum.at(list, idx) end)

    # Reverse the elements
    reversed_elements = Enum.reverse(elements)

    # Put them back with wrapping
    Enum.zip(indices, reversed_elements)
    |> Enum.reduce(list, fn {idx, val}, acc ->
      List.replace_at(acc, idx, val)
    end)
  end

  def sparse_hash(lengths_sequence, initial_list) do
    Enum.reduce(0..63, {initial_list, 0, 0}, fn _, {list, pos, skip} ->
      hash(lengths_sequence, list, pos, skip)
    end)
    |> elem(0)
  end

  def dense_hash(sparse_hash) do
    Enum.chunk_every(sparse_hash, 16)
    |> Enum.map(fn chunk -> Enum.reduce(chunk, &Bitwise.bxor(&1, &2)) end)
    |> Enum.map(&(Integer.to_string(&1, 16) |> String.pad_leading(2, "0")))
    |> Enum.join("")
    |> String.downcase()
  end

  def build_grid(input) do
    list = for i <- 0..255, do: i

    for i <- 0..127, reduce: %{} do
      acc ->
        input_row = input <> "-" <> Integer.to_string(i)

        row =
          input_row
          |> String.to_charlist()
          |> Enum.concat([17, 31, 73, 47, 23])
          |> sparse_hash(list)
          |> dense_hash()
          |> Integer.parse(16)
          |> elem(0)
          |> Integer.to_string(2)
          |> String.pad_leading(128, "0")

        Map.put(acc, i, row)
    end
  end

  def grid_to_map(grid) do
    for i <- 0..127, reduce: %{} do
      acc ->
        for {c, j} <- grid[i] |> String.graphemes() |> Enum.with_index(), reduce: acc do
          inneracc ->
            Map.put(inneracc, {i, j}, c)
        end
    end
  end

  def find_regions(grid_map) do
    {regions, _visited} =
      for i <- 0..127,
          j <- 0..127,
          Map.has_key?(grid_map, {i, j}) && grid_map[{i, j}] == "1",
          reduce: {[], MapSet.new()} do
        {acc, visited} ->
          if MapSet.member?(visited, {i, j}) do
            {acc, visited}
          else
            new_region = fill_region(MapSet.new([{i, j}]), {i, j}, grid_map)
            {[new_region | acc], MapSet.union(visited, new_region)}
          end
      end

    regions
  end

  def fill_region(set, {i, j}, grid_map) do
    # Get neighbors that are "1" and not yet in the set
    neighbors =
      for {di, dj} <- [{0, 1}, {0, -1}, {1, 0}, {-1, 0}],
          {ni, nj} = {i + di, j + dj},
          Map.has_key?(grid_map, {ni, nj}) && grid_map[{ni, nj}] == "1",
          not MapSet.member?(set, {ni, nj}),
          do: {ni, nj}

    # Recursively fill all neighbors
    Enum.reduce(neighbors, set, fn neighbor, acc ->
      acc
      |> MapSet.put(neighbor)
      |> fill_region(neighbor, grid_map)
    end)
  end
end
