defmodule Aoc.Day12Test do
  use ExUnit.Case

  import Elixir.Aoc.Day12

  def test_input() do
    """
    0 <-> 2
    1 <-> 1
    2 <-> 0, 3, 4
    3 <-> 2, 4
    4 <-> 2, 3, 6
    5 <-> 6
    6 <-> 4, 5
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 6
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 2
  end
end
