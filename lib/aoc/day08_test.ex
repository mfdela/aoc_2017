defmodule Aoc.Day08Test do
  use ExUnit.Case

  import Elixir.Aoc.Day08

  def test_input() do
    """
    b inc 5 if a > 1
    a inc 1 if b < 5
    c dec -10 if a >= 1
    c inc -20 if c == 10
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 1
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 10
  end
end
