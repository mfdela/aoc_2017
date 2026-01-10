defmodule Aoc.Day01Test do
  use ExUnit.Case

  import Elixir.Aoc.Day01

  def test_input() do
    "91212129"
  end

  def test_input2() do
    "1212"
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 9
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 6
  end
end
