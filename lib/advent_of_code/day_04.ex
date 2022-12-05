defmodule AdventOfCode.Day04 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&nb_complete_overlaps/1)
    |> Enum.sum()
  end

  defp nb_complete_overlaps(line) do
    [elve1_x, elve1_y, elve2_x, elve2_y] =
      String.split(line, [",", "-"])
      |> Enum.map(&String.to_integer/1)

    if (elve1_y - elve1_x >= elve2_y - elve2_x and
          (elve1_x <= elve2_x && elve1_y >= elve2_y)) or
         (elve1_y - elve1_x < elve2_y - elve2_x and
            (elve2_x <= elve1_x &&
               elve2_y >= elve1_y)) do
      1
    else
      0
    end
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&nb_overlaps/1)
    |> Enum.sum()
  end

  defp nb_overlaps(line) do
    [elve1_x, elve1_y, elve2_x, elve2_y] =
      String.split(line, [",", "-"])
      |> Enum.map(&String.to_integer/1)

    if (elve1_x >= elve2_x and elve1_x <= elve2_y) or
         (elve1_y >= elve2_x and elve1_y <= elve2_y) or
         (elve2_x >= elve1_x and elve2_x <= elve1_y) or
         (elve2_y >= elve1_x and elve2_y <= elve1_y) do
      1
    else
      0
    end
  end
end
