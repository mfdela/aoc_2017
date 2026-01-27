defmodule Aoc.Day20Test do
  use ExUnit.Case

  import Elixir.Aoc.Day20

  def test_input() do
    """
    p=<3,0,0>, v=<2,0,0>, a=<-1,0,0>
    p=<4,0,0>, v=<0,0,0>, a=<-2,0,0>
    """
  end

  def test_input_with_collision() do
    """
    p=<-6,0,0>, v=<3,0,0>, a=<0,0,0>
    p=<-4,0,0>, v=<2,0,0>, a=<0,0,0>
    p=<-2,0,0>, v=<1,0,0>, a=<0,0,0>
    p=<3,0,0>, v=<-1,0,0>, a=<0,0,0>
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 0
  end

  test "part2" do
    input = test_input_with_collision()
    result = part2(input)

    assert result == 1
  end
end
