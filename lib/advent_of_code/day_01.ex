defmodule AdventOfCode.Day01 do
  def part1(args) do
    args
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.filter(&(&1 != [""]))
    |> Enum.map(fn lutin ->
      lutin
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()
    end)
    |> Enum.max()
  end

  def part2(args) do
    args
    |> String.split("\n\n")
    |> Enum.map(fn lutin ->
      lutin
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn line ->
        line |> String.trim() |> String.to_integer()
      end)
      |> Enum.sum()
    end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end
end
