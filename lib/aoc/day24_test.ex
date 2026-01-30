defmodule Aoc.Day24Test do
  use ExUnit.Case

  import Elixir.Aoc.Day24

  def test_input() do
    """
    0/2
    2/2
    2/3
    3/4
    3/5
    0/1
    10/1
    9/10
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 31
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 19
  end
end
