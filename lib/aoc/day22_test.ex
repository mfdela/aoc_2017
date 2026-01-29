defmodule Aoc.Day22Test do
  use ExUnit.Case

  import Elixir.Aoc.Day22

  def test_input() do
    """
    ..#
    #..
    ...
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input, 70)

    assert result == 41
  end

  test "part2 - 100 bursts" do
    input = test_input()
    result = part2(input, 100)

    assert result == 26
  end

  @tag timeout: 120_000
  test "part2 - 10,000,000 bursts" do
    input = test_input()
    result = part2(input, 10_000_000)

    assert result == 2_511_944
  end
end
