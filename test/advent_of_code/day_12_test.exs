defmodule AdventOfCode.Day12Test do
  use ExUnit.Case

  import AdventOfCode.Day12

  @input1 """
  start-A
  start-b
  A-c
  A-b
  b-d
  A-end
  b-end
  """

  @input2 """
  dc-end
  HN-start
  start-kj
  dc-start
  dc-HN
  LN-dc
  HN-end
  kj-sa
  kj-HN
  kj-dc
  """

  @input3 """
  fs-end
  he-DX
  fs-he
  start-DX
  pj-DX
  end-zg
  zg-sl
  zg-pj
  pj-he
  RW-he
  fs-DX
  pj-RW
  zg-RW
  start-pj
  he-WI
  zg-he
  pj-fs
  start-RW
  """

  @tag :skip
  test "part1" do
    result = part1(@input1)
    assert result == 10

    result = part1(@input2)
    assert result == 19

    result = part1(@input3)
    assert result == 226
  end

  @tag :skip
  test "part2" do
    result = part2(@input1)
    assert result == 36

    result = part2(@input2)
    assert result == 103

    result = part2(@input3)
    assert result == 3509
  end
end
