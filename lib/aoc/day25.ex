defmodule Aoc.Day25 do
  def part1(args) do
    {initial_state, steps, states} = parse(args)

    # Run the Turing machine
    tape = run_turing_machine(initial_state, steps, states)

    # Calculate diagnostic checksum (count 1s)
    calculate_checksum(tape)
  end

  def parse(input) do
    lines = String.split(input, "\n", trim: true)

    # Parse initial state from first line: "Begin in state A."
    [initial_state] = Regex.run(~r/Begin in state ([A-Z])\./, hd(lines), capture: :all_but_first)

    # Parse number of steps from second line: "Perform a diagnostic checksum after 12683008 steps."
    [steps_str] = Regex.run(~r/after (\d+) steps/, Enum.at(lines, 1), capture: :all_but_first)
    steps = String.to_integer(steps_str)

    # Parse states (skip first 2 lines)
    states = parse_states(Enum.drop(lines, 2))

    {initial_state, steps, states}
  end

  def parse_states(lines) do
    # Group lines by state
    lines
    |> Enum.chunk_by(fn line -> String.starts_with?(line, "In state") end)
    |> Enum.chunk_every(2)
    |> Enum.reduce(%{}, fn [header_chunk, body_chunk], acc ->
      [header | _] = header_chunk
      [state] = Regex.run(~r/In state ([A-Z]):/, header, capture: :all_but_first)

      # Parse the two conditions (value 0 and value 1)
      state_rules = parse_state_rules(body_chunk)
      Map.put(acc, state, state_rules)
    end)
  end

  def parse_state_rules(lines) do
    # Split into two groups: one for "If the current value is 0" and one for "If the current value is 1"
    lines
    |> Enum.chunk_by(fn line -> String.contains?(line, "If the current value is") end)
    |> Enum.reject(fn chunk -> length(chunk) == 1 end)
    |> Enum.map(fn chunk ->
      # Each chunk has 3 lines: write value, move direction, next state
      [write_line, move_line, next_state_line] = chunk

      [value] = Regex.run(~r/Write the value (\d)\./, write_line, capture: :all_but_first)
      write_value = String.to_integer(value)

      [direction] = Regex.run(~r/Move one slot to the (left|right)\./, move_line, capture: :all_but_first)
      move_dir = if direction == "left", do: -1, else: 1

      [next_state] = Regex.run(~r/Continue with state ([A-Z])\./, next_state_line, capture: :all_but_first)

      {write_value, move_dir, next_state}
    end)
    |> then(fn [rule0, rule1] -> %{0 => rule0, 1 => rule1} end)
  end

  def run_turing_machine(initial_state, steps, states) do
    # Use a map to represent the tape (sparse representation)
    # Only store positions with value 1, all others are implicitly 0
    tape = %{}
    cursor = 0
    state = initial_state

    run_steps(tape, cursor, state, states, steps)
  end

  def run_steps(tape, _cursor, _state, _states, 0), do: tape

  def run_steps(tape, cursor, state, states, remaining_steps) do
    # Get current value at cursor (default to 0)
    current_value = Map.get(tape, cursor, 0)

    # Get the rule for this state and current value
    {write_value, move_dir, next_state} = states[state][current_value]

    # Update tape
    new_tape = if write_value == 1 do
      Map.put(tape, cursor, 1)
    else
      Map.delete(tape, cursor)
    end

    # Move cursor
    new_cursor = cursor + move_dir

    # Continue with next state
    run_steps(new_tape, new_cursor, next_state, states, remaining_steps - 1)
  end

  def calculate_checksum(tape) do
    # Count the number of 1s on the tape
    map_size(tape)
  end

  def part2(_args) do
    # Day 25 typically has no part 2
    "Merry Christmas!"
  end
end
