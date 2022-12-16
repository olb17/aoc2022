defmodule AdventOfCode.Day13Test do
  use ExUnit.Case

  import AdventOfCode.Day13

  @input2 """
  [[[]]]
  [[]]

  """

  @input """
  [1,1,3,1,1]
  [1,1,5,1,1]

  [[1],[2,3,4]]
  [[1],4]

  [9]
  [[8,7,6]]

  [[4,4],4,4]
  [[4,4],4,4,4]

  [7,7,7,7]
  [7,7,7]

  []
  [3]

  [[[]]]
  [[]]

  [1,[2,[3,[4,[5,6,7]]]],8,9]
  [1,[2,[3,[4,[5,6,0]]]],8,9]
  """

  @input2 """
  [[[8],[2,[6,5,1]],1,[[3,0,8],7]],[[7,[1,3,3],[],7,0],[0,[1],10,1,5],[10,[7],[6,3],5,0],[[3,9,6,1,8],5,9,[3,3,10]],[7,[1,9,3,5,8],0,5]],[5,10,2,[7,[2,4,8,4],6],[[3,8,5,7,1],[9,8],[2,6,9,4],7,10]],[[[5],[4,1]]],[5]]
  [[[[8]],5,7]]
  """

  @tag :skip2
  test "part1" do
    input = @input
    result = part1(input)

    assert result == 13
    assert part1(@input2) == 1
  end

  @tag :skip2
  test "part2" do
    input = @input
    result = part2(input)

    assert result == 140
  end
end
