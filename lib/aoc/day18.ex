defmodule Aoc.Day18 do
  def part1(args) do
    instructions = parse(args)
    initial_state = %{
      registers: %{},
      ip: 0,
      last_sound: nil
    }
    execute_part1(instructions, initial_state)
  end

  def part2(args) do
    instructions = parse(args)
    run_concurrent_programs(instructions)
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_instruction/1)
  end

  def parse_instruction(<<"snd ", register::binary>>) do
    {:snd, register}
  end

  def parse_instruction(<<"set ", rest::binary>>) do
    [register, value] = String.split(rest, " ")
    {:set, register, value}
  end

  def parse_instruction(<<"add ", rest::binary>>) do
    [register, value] = String.split(rest, " ")
    {:add, register, value}
  end

  def parse_instruction(<<"mul ", rest::binary>>) do
    [register, value] = String.split(rest, " ")
    {:mul, register, value}
  end

  def parse_instruction(<<"mod ", rest::binary>>) do
    [register, value] = String.split(rest, " ")
    {:mod, register, value}
  end


  def parse_instruction(<<"rcv ", value::binary>>) do
    {:rcv, value}
  end

  def parse_instruction(<<"jgz ", rest::binary>>) do
    [value, offset] = String.split(rest, " ")
    {:jgz, value, offset}
  end


  # Part 1: Single program execution
  def execute_part1(instructions, state) do
    case Enum.at(instructions, state.ip) do
      nil ->
        nil

      instruction ->
        case execute_instruction_part1(instruction, state) do
          {:halt, recovered_value} ->
            recovered_value

          {:ok, new_state} ->
            execute_part1(instructions, new_state)
        end
    end
  end

  def execute_instruction_part1({:snd, value}, state) do
    val = get_value(value, state)
    new_state = %{state |
      last_sound: val,
      ip: state.ip + 1
    }
    {:ok, new_state}
  end

  def execute_instruction_part1({:rcv, value}, state) do
    check_val = get_value(value, state)

    if check_val != 0 do
      # Recover the last sound and halt
      {:halt, state.last_sound}
    else
      new_state = %{state | ip: state.ip + 1}
      {:ok, new_state}
    end
  end

  def execute_instruction_part1({:set, register, value}, state) do
    val = get_value(value, state)
    new_state = %{state |
      registers: Map.put(state.registers, register, val),
      ip: state.ip + 1
    }
    {:ok, new_state}
  end

  def execute_instruction_part1({:add, register, value}, state) do
    val = get_value(value, state)
    current = Map.get(state.registers, register, 0)
    new_state = %{state |
      registers: Map.put(state.registers, register, current + val),
      ip: state.ip + 1
    }
    {:ok, new_state}
  end

  def execute_instruction_part1({:mul, register, value}, state) do
    val = get_value(value, state)
    current = Map.get(state.registers, register, 0)
    new_state = %{state |
      registers: Map.put(state.registers, register, current * val),
      ip: state.ip + 1
    }
    {:ok, new_state}
  end

  def execute_instruction_part1({:mod, register, value}, state) do
    val = get_value(value, state)
    current = Map.get(state.registers, register, 0)
    new_state = %{state |
      registers: Map.put(state.registers, register, rem(current, val)),
      ip: state.ip + 1
    }
    {:ok, new_state}
  end

  def execute_instruction_part1({:jgz, value, offset}, state) do
    check_val = get_value(value, state)

    if check_val > 0 do
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

  # Part 2: Concurrent program execution
  def run_concurrent_programs(instructions) do
    coordinator_pid = self()

    # Spawn both programs
    pid0 = spawn(fn -> program_loop(instructions, 0, coordinator_pid) end)
    pid1 = spawn(fn -> program_loop(instructions, 1, coordinator_pid) end)

    # Send each program the other's PID
    send(pid0, {:init, pid1})
    send(pid1, {:init, pid0})

    # Monitor for deadlock
    monitor_programs(pid0, pid1)
  end

  def monitor_programs(pid0, pid1, waiting0 \\ false, waiting1 \\ false) do
    receive do
      {:waiting, ^pid0} ->
        if waiting1 do
          # Both waiting - deadlock detected
          send(pid0, :terminate)
          send(pid1, :terminate)

          # Collect results
          receive do
            {:result, 1, count} -> count
          after
            1000 -> 0
          end
        else
          monitor_programs(pid0, pid1, true, waiting1)
        end

      {:waiting, ^pid1} ->
        if waiting0 do
          # Both waiting - deadlock detected
          send(pid0, :terminate)
          send(pid1, :terminate)

          # Collect results
          receive do
            {:result, 1, count} -> count
          after
            1000 -> 0
          end
        else
          monitor_programs(pid0, pid1, waiting0, true)
        end

      {:running, ^pid0} ->
        monitor_programs(pid0, pid1, false, waiting1)

      {:running, ^pid1} ->
        monitor_programs(pid0, pid1, waiting0, false)

      {:terminated, program_id, count} ->
        # One program terminated naturally
        send(pid0, :terminate)
        send(pid1, :terminate)

        # Collect result from program 1
        if program_id == 1 do
          count
        else
          receive do
            {:result, 1, c} -> c
            {:terminated, 1, c} -> c
          after
            1000 -> 0
          end
        end
    end
  end

  def program_loop(instructions, program_id, coordinator_pid) do
    # Wait for initialization
    other_pid = receive do
      {:init, pid} -> pid
    end

    initial_state = %{
      registers: %{"p" => program_id},
      ip: 0,
      other_pid: other_pid,
      coordinator_pid: coordinator_pid,
      send_count: 0,
      program_id: program_id
    }

    execute_concurrent(instructions, initial_state)
  end

  def execute_concurrent(instructions, state) do
    # Check for termination signal
    terminate? = receive do
      :terminate -> true
    after
      0 -> false
    end

    if terminate? do
      send(state.coordinator_pid, {:result, state.program_id, state.send_count})
      :ok
    else
      case Enum.at(instructions, state.ip) do
        nil ->
          # Program finished
          send(state.coordinator_pid, {:terminated, state.program_id, state.send_count})
          :ok

        instruction ->
          case execute_instruction_concurrent(instruction, state) do
            {:ok, new_state} ->
              execute_concurrent(instructions, new_state)

            {:blocked, new_state} ->
              # Waiting for a message
              send(state.coordinator_pid, {:waiting, self()})

              receive do
                :terminate ->
                  send(state.coordinator_pid, {:result, state.program_id, state.send_count})
                  :ok

                {:value, val} ->
                  # Got a value, update state and continue
                  send(state.coordinator_pid, {:running, self()})

                  case instruction do
                    {:rcv, register} ->
                      updated_state = %{new_state |
                        registers: Map.put(new_state.registers, register, val),
                        ip: new_state.ip + 1
                      }
                      execute_concurrent(instructions, updated_state)
                  end
              end
          end
      end
    end
  end

  def execute_instruction_concurrent({:snd, value}, state) do
    val = get_value(value, state)
    send(state.other_pid, {:value, val})

    new_state = %{state |
      send_count: state.send_count + 1,
      ip: state.ip + 1
    }
    {:ok, new_state}
  end

  def execute_instruction_concurrent({:rcv, register}, state) do
    # Try to receive without blocking
    msg = receive do
      {:value, val} -> val
    after
      0 -> nil
    end

    if msg != nil do
      new_state = %{state |
        registers: Map.put(state.registers, register, msg),
        ip: state.ip + 1
      }
      {:ok, new_state}
    else
      # No message available, need to block
      {:blocked, state}
    end
  end

  def execute_instruction_concurrent({:set, register, value}, state) do
    val = get_value(value, state)
    new_state = %{state |
      registers: Map.put(state.registers, register, val),
      ip: state.ip + 1
    }
    {:ok, new_state}
  end

  def execute_instruction_concurrent({:add, register, value}, state) do
    val = get_value(value, state)
    current = Map.get(state.registers, register, 0)
    new_state = %{state |
      registers: Map.put(state.registers, register, current + val),
      ip: state.ip + 1
    }
    {:ok, new_state}
  end

  def execute_instruction_concurrent({:mul, register, value}, state) do
    val = get_value(value, state)
    current = Map.get(state.registers, register, 0)
    new_state = %{state |
      registers: Map.put(state.registers, register, current * val),
      ip: state.ip + 1
    }
    {:ok, new_state}
  end

  def execute_instruction_concurrent({:mod, register, value}, state) do
    val = get_value(value, state)
    current = Map.get(state.registers, register, 0)
    new_state = %{state |
      registers: Map.put(state.registers, register, rem(current, val)),
      ip: state.ip + 1
    }
    {:ok, new_state}
  end

  def execute_instruction_concurrent({:jgz, value, offset}, state) do
    check_val = get_value(value, state)

    if check_val > 0 do
      offset_val = get_value(offset, state)
      new_state = %{state | ip: state.ip + offset_val}
      {:ok, new_state}
    else
      new_state = %{state | ip: state.ip + 1}
      {:ok, new_state}
    end
  end
end
