defmodule Aoc.Day03Test do
  use ExUnit.Case

  import Elixir.Aoc.Day03

  def test_input() do
    23
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 2
  end

  test "part2" do
    # According to the problem:
    # The first few values are: 1, 1, 2, 4, 5, 10, 11, 23, 25, 26, 54, 57, 59, 122, 133, 142, 147, 304, 330, 351, 362, 747, 806...
    # For input 23, the first value larger than 23 should be 25
    assert part2(1) == 2
    assert part2(2) == 4
    assert part2(4) == 5
    assert part2(5) == 10
    assert part2(23) == 25
    assert part2(747) == 806
  end
end
