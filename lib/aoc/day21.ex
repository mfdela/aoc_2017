defmodule Aoc.Day21 do
  def part1(args, num_iterations \\ 5) do
    rules = parse_rules(args)

    iterations(rules, start(), num_iterations)
    |> List.flatten()
    |> Enum.count(&(&1 == "#"))
  end

  def part2(args, num_iterations \\ 18) do
    rules = parse_rules(args)

    iterations(rules, start(), num_iterations)
    |> List.flatten()
    |> Enum.count(&(&1 == "#"))
  end

  def iterations(rules, pattern, n) do
    Enum.reduce(1..n, pattern, fn _, pattern ->
      pattern
      |> iterate(rules)
    end)
  end

  def parse_rules(rules) do
    rules
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [input_rule, output_rule] =
        String.split(line, " => ") |> Enum.map(&String.split(&1, "/", trim: true))

      {input_rule |> Enum.map(&String.graphemes/1), output_rule |> Enum.map(&String.graphemes/1)}
    end)
  end

  def start() do
    [[".", "#", "."], [".", ".", "#"], ["#", "#", "#"]]
  end

  def match_rules(rules, pattern) do
    rules
    |> Enum.find(fn {input_rule, _output_rule} -> match_rule?(input_rule, pattern) end)
    |> case do
      {_, result} -> result
      nil -> pattern
    end
  end

  def match_rule?(input_rule, pattern) do
    # Generate all 8 possible transformations (4 rotations × 2 flip states)
    transformations = [
      pattern,
      rotate_clockwise(pattern),
      pattern |> rotate_clockwise() |> rotate_clockwise(),
      pattern |> rotate_clockwise() |> rotate_clockwise() |> rotate_clockwise(),
      flip_horizontal(pattern),
      pattern |> flip_horizontal() |> rotate_clockwise(),
      pattern |> flip_horizontal() |> rotate_clockwise() |> rotate_clockwise(),
      pattern |> flip_horizontal() |> rotate_clockwise() |> rotate_clockwise() |> rotate_clockwise()
    ]

    input_rule in transformations
  end

  def flip_horizontal(pattern) do
    pattern
    |> Enum.map(&Enum.reverse/1)
  end

  def flip_vertical(pattern) do
    pattern
    |> Enum.reverse()
  end

  def rotate_clockwise(pattern) do
    pattern
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.reverse/1)
  end

  def split(pattern, n) do
    size = length(pattern)

    for row_start <- 0..(size - 1)//n, col_start <- 0..(size - 1)//n do
      pattern
      |> Enum.slice(row_start, n)
      |> Enum.map(fn row -> Enum.slice(row, col_start, n) end)
    end
  end

  def compose(matrices) do
    # Calculate the size of each sub-matrix
    sub_size = length(List.first(matrices))
    # Calculate how many sub-matrices per row/column
    matrices_per_side = trunc(:math.sqrt(length(matrices)))

    # Group matrices into rows
    matrix_rows = Enum.chunk_every(matrices, matrices_per_side)

    # For each row of matrices, compose them horizontally, then compose all rows vertically
    matrix_rows
    |> Enum.flat_map(fn row_of_matrices ->
      # For each row index in the sub-matrices
      0..(sub_size - 1)
      |> Enum.map(fn row_idx ->
        # Concatenate the corresponding row from each matrix in this row
        row_of_matrices
        |> Enum.flat_map(fn matrix -> Enum.at(matrix, row_idx) end)
      end)
    end)
  end


  def iterate(pattern, rules) do
    factor =
      cond do
        rem(length(pattern), 2) == 0 -> 2
        rem(length(pattern), 3) == 0 -> 3
        true -> raise "Invalid pattern size"
      end

    pattern
    |> split(factor)
    |> Enum.map(&match_rules(rules, &1))
    |> compose()
  end
end
