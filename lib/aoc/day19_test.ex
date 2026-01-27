defmodule Aoc.Day19Test do
  use ExUnit.Case

  import Elixir.Aoc.Day19

  def test_input() do
    """
        |
        |  +--+
        A  |  C
    F---|----E|--+
        |  |  |  D
        +B-+  +--+
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == "ABCDEF"
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 38
  end
end
