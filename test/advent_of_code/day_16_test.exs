defmodule AdventOfCode.Day16Test do
  use ExUnit.Case

  import AdventOfCode.Day16

  @input1 "8A004A801A8002F478"
  @input2 "620080001611562C8802118E34"
  @input3 "C0015000016115A2E0802F182340"
  @input4 "A0016C880162017C3686B18A3D4780"
  @input5 "38006F45291200"
  @input6 "EE00D40C823060"

  @tag :skip_no
  test "part1" do
    assert part1("D2FE28") == 6
    # assert part1(@input5) == 9
    # assert part1(@input6) == 14
    # assert part1(@input1) == 16
    # assert part1(@input2) == 12
    # assert part1(@input3) == 23
    # assert part1(@input4) == 31
  end

  @tag :skip
  test "part2" do
    input = @input1
    result = part2(input)

    assert result == 315
  end
end
