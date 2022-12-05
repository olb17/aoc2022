defmodule AdventOfCode.Day15Test do
  use ExUnit.Case

  import AdventOfCode.Day15

  @input """
  1163751742
  1381373672
  2136511328
  3694931569
  7463417111
  1319128137
  1359912421
  3125421639
  1293138521
  2311944581
  """

  @tag :skip
  test "part1" do
    input = @input
    result = part1(input)

    assert result == 40
  end

  @tag :skip
  test "part2" do
    input = @input
    result = part2(input)

    assert result == 315
  end
end
