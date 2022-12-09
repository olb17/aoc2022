defmodule AdventOfCode.Day08Test do
  use ExUnit.Case

  import AdventOfCode.Day08

  @input """
  30373
  25512
  65332
  33549
  35390
  """

  @tag :skip2
  test "part1" do
    input = @input
    result = part1(input)

    assert result == 21
  end

  @tag :skip2
  test "part2" do
    input = @input
    result = part2(input)

    assert result == 8
  end
end
