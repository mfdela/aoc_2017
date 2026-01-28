defmodule Aoc.Day21Test do
  use ExUnit.Case

  import Elixir.Aoc.Day21

  def test_input() do
    """
    ../.# => ##./#../...
    .#./..#/### => #..#/..../..../#..#
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input, 2)

    assert result == 12
  end

  test "part2" do
    input = test_input()
    result = part2(input, 2)

    assert result == 12
  end
end
