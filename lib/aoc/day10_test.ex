defmodule Aoc.Day10Test do
  use ExUnit.Case

  import Elixir.Aoc.Day10

  def test_input() do
    "3,4,1,5"
  end

  test "part1" do
    input = test_input()
    result = part1(input, 5)

    assert result == 12
  end

  test "part2" do
    input = test_input()
    result = part2(input, 5)

    assert result
  end
end
