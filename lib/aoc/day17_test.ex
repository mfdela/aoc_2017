defmodule Aoc.Day17Test do
  use ExUnit.Case

  import Elixir.Aoc.Day17

  def test_input() do
    """
    3
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 638
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result
  end
end
