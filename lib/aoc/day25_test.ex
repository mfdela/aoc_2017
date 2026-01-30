defmodule Aoc.Day25Test do
  use ExUnit.Case

  import Aoc.Day25

  def test_input() do
    """
    Begin in state A.
    Perform a diagnostic checksum after 6 steps.

    In state A:
      If the current value is 0:
        - Write the value 1.
        - Move one slot to the right.
        - Continue with state B.
      If the current value is 1:
        - Write the value 0.
        - Move one slot to the left.
        - Continue with state B.

    In state B:
      If the current value is 0:
        - Write the value 1.
        - Move one slot to the left.
        - Continue with state A.
      If the current value is 1:
        - Write the value 1.
        - Move one slot to the right.
        - Continue with state A.
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 3
  end
end
