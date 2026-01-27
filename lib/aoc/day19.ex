defmodule Aoc.Day19 do
  def part1(args) do
    args
    |> parse()
    |> traverse()
    |> elem(0)
    |> Enum.reverse()
    |> Enum.join()
  end

  def part2(args) do
    args
    |> parse()
    |> traverse()
    |> elem(1)
    |> Map.values()
    |> Enum.sum()
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.with_index()
    |> Enum.map(fn {row, y} ->
      Enum.with_index(row)
      |> Enum.map(fn {char, x} ->
        {{x, y}, char}
      end)
    end)
    |> List.flatten()
    |> Enum.filter(fn {{_, _}, char} -> char != " " end)
    |> Map.new()
  end

  def find_start(grid) do
    {{x, y}, "|"} = Enum.find(grid, fn {{_, y}, char} -> y == 0 && char == "|" end)
    {x, y}
  end

  def traverse(grid) do
    {x, y} = find_start(grid)
    traverse({x, y, :down}, grid, [], %{:down => 0, :up => 0, :left => 0, :right => 0})
  end

  def traverse({x, y, prev_dir}, grid, letters, steps) do
    update_steps = Map.update(steps, prev_dir, 1, &(&1 + 1))

    {{dx, dy}, next_dir} =
      case Map.get(grid, {x, y}) do
        nil -> {{0, 0}, :halt}
        "|" -> {next(prev_dir), prev_dir}
        "-" -> {next(prev_dir), prev_dir}
        "+" -> change_direction({x, y, prev_dir}, grid)
        _ -> {next(prev_dir), :letter}
      end

    # |> IO.inspect(label: "next_dir")

    case next_dir do
      :halt ->
        {letters, steps}

      :letter ->
        traverse(
          {x + dx, y + dy, prev_dir},
          grid,
          [Map.get(grid, {x, y}) | letters],
          update_steps
        )

      _ ->
        traverse({x + dx, y + dy, next_dir}, grid, letters, update_steps)
    end
  end

  def next(prev_dir) do
    case prev_dir do
      :down -> {0, 1}
      :up -> {0, -1}
      :left -> {-1, 0}
      :right -> {1, 0}
    end
  end

  def change_direction({x, y, prev_dir}, grid) do
    case prev_dir do
      dir when dir in [:down, :up] ->
        find_horizontal_direction({x, y}, grid)

      dir when dir in [:left, :right] ->
        find_vertical_direction({x, y}, grid)

      _ ->
        :error
    end
  end

  defp find_horizontal_direction({x, y}, grid) do
    cond do
      Map.get(grid, {x + 1, y}) == "-" or
          Map.get(grid, {x + 1, y}, "") |> String.match?(~r/[A-Z]/) ->
        {{1, 0}, :right}

      Map.get(grid, {x - 1, y}) == "-" or
          Map.get(grid, {x - 1, y}, "") |> String.match?(~r/[A-Z]/) ->
        {{-1, 0}, :left}

      true ->
        :error
    end
  end

  defp find_vertical_direction({x, y}, grid) do
    cond do
      Map.get(grid, {x, y + 1}) == "|" or
          Map.get(grid, {x, y + 1}, "") |> String.match?(~r/[A-Z]/) ->
        {{0, 1}, :down}

      Map.get(grid, {x, y - 1}) == "|" or
          Map.get(grid, {x, y - 1}, "") |> String.match?(~r/[A-Z]/) ->
        {{0, -1}, :up}

      true ->
        :error
    end
  end
end
