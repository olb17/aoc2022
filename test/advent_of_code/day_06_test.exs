defmodule AdventOfCode.Day06Test do
  use ExUnit.Case

  import AdventOfCode.Day06

  @input1 "mjqjpqmgbljsphdztnvjfqwrcgsmlb"
  @input2 "bvwbjplbgvbhsrlpgdmjqwftvncz"
  @input3 "nppdvjthqldpwncqszvftbrmjlhg"
  @input4 "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"
  @input5 "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"

  @tag :skip2
  test "part1" do
    assert part1(@input1) == 7
    assert part1(@input2) == 5
    assert part1(@input3) == 6
    assert part1(@input4) == 10
    assert part1(@input5) == 11
  end

  @tag :skip2
  test "part2" do
    assert part2(@input1) == 19
    assert part2(@input2) == 23
    assert part2(@input3) == 23
    assert part2(@input4) == 29
    assert part2(@input5) == 26
  end
end
