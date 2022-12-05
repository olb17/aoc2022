defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  @input "1000
  2000
  3000

  4000

  5000
  6000

  7000
  8000
  9000

  10000
  "

  @tag :skip2
  test "part1" do
    input = @input
    result = part1(input)

    assert result == 24_000
  end

  @tag :skip2
  test "part2" do
    input = @input
    result = part2(input)

    assert result == 45_000
  end
end
