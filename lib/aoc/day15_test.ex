defmodule Aoc.Day15Test do
  use ExUnit.Case

  import Elixir.Aoc.Day15

  def test_input() do
    """
    Generator A starts with 65
    Generator B starts with 8921
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result
  end
end
