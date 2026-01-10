defmodule Aoc.Day05Test do
  use ExUnit.Case

  import Elixir.Aoc.Day05

  def test_input() do
    """
    0
    3
    0
    1
    -3
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 5
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 10
  end
end
