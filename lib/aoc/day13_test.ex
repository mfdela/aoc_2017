defmodule Aoc.Day13Test do
  use ExUnit.Case

  import Elixir.Aoc.Day13

  def test_input() do
    """
    0: 3
    1: 2
    4: 4
    6: 4
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 24
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 10
  end
end
