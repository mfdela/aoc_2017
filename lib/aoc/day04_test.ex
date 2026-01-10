defmodule Aoc.Day04Test do
  use ExUnit.Case

  import Elixir.Aoc.Day04

  def test_input() do
    """
    aa bb cc dd ee
    aa bb cc dd aa
    aa bb cc dd aaa
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 2
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 2
  end
end
