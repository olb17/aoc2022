defmodule AdventOfCode.Day12Test do
  use ExUnit.Case

  import AdventOfCode.Day12

  @input """
  Sabqponm
  abcryxxl
  accszExk
  acctuvwj
  abdefghi

  """

  @tag :skip2
  test "part1" do
    result = part1(@input)
    assert result == 31
  end

  @tag :skip2
  test "part2" do
    result = part2(@input)
    assert result == 29
  end
end
