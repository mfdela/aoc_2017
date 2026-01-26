defmodule Aoc.Day18Test do
  use ExUnit.Case

  import Elixir.Aoc.Day18

  def test_input() do
    """
    set a 1
    add a 2
    mul a a
    mod a 5
    snd a
    set a 0
    rcv a
    jgz a -1
    set a 1
    jgz a -2
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 4
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result
  end
end
