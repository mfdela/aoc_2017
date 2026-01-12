defmodule Aoc.Day08 do
  def part1(args) do
    args
    |> parse()
    |> Enum.reduce({%{}, 0}, &execute_instruction/2)
    |> elem(0)
    |> Map.values()
    |> Enum.max()
  end

  def part2(args) do
    args
    |> parse()
    |> Enum.reduce({%{}, 0}, &execute_instruction/2)
    |> elem(1)
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    [register, operation, value, condition_register, condition, condition_value] =
      Regex.run(~r/(\w+) (inc|dec) (-?\d+) if (\w+) (>|>=|<|<=|==|!=) (-?\d+)/, line,
        capture: :all_but_first
      )

    {register, operation, String.to_integer(value), condition_register, condition,
     String.to_integer(condition_value)}
  end

  def execute_instruction(
        {register, operation, value, condition_register, condition, condition_value},
        {state, max}
      ) do
    new_state =
      if evaluate_condition(condition_register, condition, condition_value, state) do
        case operation do
          "inc" -> Map.update(state, register, value, &(&1 + value))
          "dec" -> Map.update(state, register, -value, &(&1 - value))
        end
      else
        state
      end

    new_max =
      case Map.values(new_state) do
        [] -> max
        values -> max(max, Enum.max(values))
      end

    {new_state, new_max}
  end

  def evaluate_condition(register, condition, value, state) do
    case condition do
      ">" -> Map.get(state, register, 0) > value
      ">=" -> Map.get(state, register, 0) >= value
      "<" -> Map.get(state, register, 0) < value
      "<=" -> Map.get(state, register, 0) <= value
      "==" -> Map.get(state, register, 0) == value
      "!=" -> Map.get(state, register, 0) != value
    end
  end
end
