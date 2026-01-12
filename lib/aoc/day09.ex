defmodule Aoc.Day09 do
  def part1(args) do
    args
    |> String.trim()
    |> String.graphemes()
    |> process()
    |> elem(0)
  end

  def part2(args) do
    args
    |> String.trim()
    |> String.graphemes()
    |> process()
    |> elem(1)
  end

  # Process the stream with a state machine
  # States: :normal, :in_garbage, :cancel
  # Returns {total_score, garbage_count}
  def process(chars), do: process_chars(chars, :normal, 0, 0, 0)

  # Base case - no more characters
  def process_chars([], _state, _depth, score, garbage_count), do: {score, garbage_count}

  # State: :cancel - ignore next character and go back to :in_garbage
  def process_chars([_char | rest], :cancel, depth, score, garbage_count),
    do: process_chars(rest, :in_garbage, depth, score, garbage_count)

  # State: :in_garbage - handle cancel character
  def process_chars(["!" | rest], :in_garbage, depth, score, garbage_count),
    do: process_chars(rest, :cancel, depth, score, garbage_count)

  # State: :in_garbage - end of garbage
  def process_chars([">" | rest], :in_garbage, depth, score, garbage_count),
    do: process_chars(rest, :normal, depth, score, garbage_count)

  # State: :in_garbage - count garbage character
  def process_chars([_char | rest], :in_garbage, depth, score, garbage_count),
    do: process_chars(rest, :in_garbage, depth, score, garbage_count + 1)

  # State: :normal - start garbage
  def process_chars(["<" | rest], :normal, depth, score, garbage_count),
    do: process_chars(rest, :in_garbage, depth, score, garbage_count)

  # State: :normal - open group
  def process_chars(["{" | rest], :normal, depth, score, garbage_count),
    do: process_chars(rest, :normal, depth + 1, score + depth + 1, garbage_count)

  # State: :normal - close group
  def process_chars(["}" | rest], :normal, depth, score, garbage_count),
    do: process_chars(rest, :normal, depth - 1, score, garbage_count)

  # State: :normal - comma (just skip)
  def process_chars(["," | rest], :normal, depth, score, garbage_count),
    do: process_chars(rest, :normal, depth, score, garbage_count)

  # Catch-all for any other character in normal state (shouldn't happen)
  def process_chars([_char | rest], :normal, depth, score, garbage_count),
    do: process_chars(rest, :normal, depth, score, garbage_count)
end
