defmodule Aoc.Day23 do
  def part1(args) do
    instructions = parse(args)

    initial_state = %{
      registers: %{},
      ip: 0,
      cycle_count: 0,
      mul_count: 0
    }

    end_state = execute(instructions, initial_state)
    end_state.mul_count
  end

  def part2(_args) do
    # The assembly code counts composite (non-prime) numbers
    # When a=1:
    # Line 0-2: b = 81, c = 81, then jump to line 4
    # Line 4-5: b = 81 * 100 + 100000 = 108100
    # Line 6-7: c = b + 17000 = 125100
    # Lines 8-31: Loop from b=108100 to c=125100 in steps of 17
    #             Count how many are composite (not prime)

    start_val = 108100
    end_val = 125100
    step = 17

    start_val..end_val//step
    |> Enum.count(&is_composite?/1)
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_instruction/1)
  end

  def parse_instruction(<<"set ", rest::binary>>) do
    [register, value] = String.split(rest, " ")
    {:set, register, value}
  end

  def parse_instruction(<<"sub ", rest::binary>>) do
    [register, value] = String.split(rest, " ")
    {:sub, register, value}
  end

  def parse_instruction(<<"mul ", rest::binary>>) do
    [register, value] = String.split(rest, " ")
    {:mul, register, value}
  end

  def parse_instruction(<<"jnz ", rest::binary>>) do
    [value, offset] = String.split(rest, " ")
    {:jnz, value, offset}
  end

  def execute(instructions, state) do
    next_instruction = Enum.at(instructions, state.ip)
    cond do
      is_nil(next_instruction) or state.cycle_count > 100000 ->
        state

      true ->
        {:ok, new_state} = execute_instruction(next_instruction, state)
        execute(instructions, %{new_state | cycle_count: new_state.cycle_count + 1})
    end
  end

  def execute_instruction({:set, register, value}, state) do
    val = get_value(value, state)
    new_state = %{state | registers: Map.put(state.registers, register, val), ip: state.ip + 1}
    {:ok, new_state}
  end

  def execute_instruction({:sub, register, value}, state) do
    val = get_value(value, state)
    current = Map.get(state.registers, register, 0)

    new_state = %{
      state
      | registers: Map.put(state.registers, register, current - val),
        ip: state.ip + 1
    }

    {:ok, new_state}
  end

  def execute_instruction({:mul, register, value}, state) do
    val = get_value(value, state)
    current = Map.get(state.registers, register, 0)

    new_state = %{
      state
      | registers: Map.put(state.registers, register, current * val),
        ip: state.ip + 1,
        mul_count: state.mul_count + 1
    }

    {:ok, new_state}
  end

  def execute_instruction({:jnz, value, offset}, state) do
    check_val = get_value(value, state)

    if check_val != 0 do
      offset_val = get_value(offset, state)
      new_state = %{state | ip: state.ip + offset_val}
      {:ok, new_state}
    else
      new_state = %{state | ip: state.ip + 1}
      {:ok, new_state}
    end
  end

  def get_value(value, state) do
    case Integer.parse(value) do
      {val, _} -> val
      :error -> Map.get(state.registers, value, 0)
    end
  end

  # Check if a number is composite (not prime)
  def is_composite?(n) when n < 2, do: true
  def is_composite?(2), do: false
  def is_composite?(n) do
    # A number is composite if it has any divisor from 2 to sqrt(n)
    limit = :math.sqrt(n) |> floor()

    2..limit
    |> Enum.any?(fn d -> rem(n, d) == 0 end)
  end


end
