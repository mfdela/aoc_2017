defmodule Aoc.Day02Test do
  use ExUnit.Case

  import Elixir.Aoc.Day02

  def test_input() do
    """
    5 1 9 5
    7 5 3
    2 4 6 8
    """
  end

  def test_input2() do
    """
    5 9 2 8
    9 4 7 3
    3 8 6 5
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 18
  end

  test "part2" do
    input = test_input2()
    result = part2(input)

    assert result == 9
  end
end
