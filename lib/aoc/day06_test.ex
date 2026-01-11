defmodule Aoc.Day06Test do
  use ExUnit.Case

  import Elixir.Aoc.Day06

  def test_input() do
    """
    0 2 7 0
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

    assert result == 4
  end
end
