defmodule Aoc.Day16Test do
  use ExUnit.Case

  import Elixir.Aoc.Day16

  def test_input() do
    """
    s1,x3/4,pe/b
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input, "abcde")

    assert result == "baedc"
  end

  test "part2" do
    input = test_input()
    result = part2(input, "abcde")

    assert result
  end
end
