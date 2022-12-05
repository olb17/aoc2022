defmodule AdventOfCode.Day05Test do
  use ExUnit.Case

  import AdventOfCode.Day05

  @input """
  0,9 -> 5,9
  8,0 -> 0,8
  9,4 -> 3,4
  2,2 -> 2,1
  7,0 -> 7,4
  6,4 -> 2,0
  0,9 -> 2,9
  3,4 -> 1,4
  0,0 -> 8,8
  5,5 -> 8,2
  """

  @tag :skip
  test "part1" do
    input = @input
    result = part1(input)

    assert result == 5934
  end

  @tag :skip
  test "part2" do
    input = @input
    result = part2(input)

    assert result == 12
  end
end
