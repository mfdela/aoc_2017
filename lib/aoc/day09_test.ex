defmodule Aoc.Day09Test do
  use ExUnit.Case

  import Elixir.Aoc.Day09

  def test_input() do
    "{{<!!>},{<!!>},{<!!>},{<!!>}}"
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 9
  end

  test "part1 examples" do
    # From the problem description
    assert part1("{}") == 1
    assert part1("{{{}}}") == 6
    assert part1("{{},{}}") == 5
    assert part1("{{{},{},{{}}}}") == 16
    assert part1("{<a>,<a>,<a>,<a>}") == 1
    assert part1("{{<ab>},{<ab>},{<ab>},{<ab>}}") == 9
    assert part1("{{<!!>},{<!!>},{<!!>},{<!!>}}") == 9
    assert part1("{{<a!>},{<a!>},{<a!>},{<ab>}}") == 3
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 0
  end

  test "part2 examples" do
    # Garbage counting examples
    assert part2("<>") == 0
    assert part2("<random characters>") == 17
    assert part2("<<<<>") == 3
    assert part2("<{!>}>") == 2
    assert part2("<!!>") == 0
    assert part2("<!!!>>") == 0
    assert part2("<{o\"i!a,<{i<a>") == 10
  end
end
