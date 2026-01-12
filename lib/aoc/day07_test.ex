defmodule Aoc.Day07Test do
  use ExUnit.Case

  import Elixir.Aoc.Day07

  def test_input() do
    """
    pbga (66)
    xhth (57)
    ebii (61)
    havc (66)
    ktlj (57)
    fwft (72) -> ktlj, cntj, xhth
    qoyq (66)
    padx (45) -> pbga, havc, qoyq
    tknk (41) -> ugml, padx, fwft
    jptl (61)
    ugml (68) -> gyxo, ebii, jptl
    gyxo (61)
    cntj (57)
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == "tknk"
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 60
  end
end
