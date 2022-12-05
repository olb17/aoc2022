defmodule AdventOfCode.Day01 do
  def part1(args) do
    args
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(fn lutin ->
      lutin
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line |> String.trim() |> String.to_integer()
      end)
      |> Enum.sum()
    end)
    |> Enum.max()
  end

  def part2(args) do
    args
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(fn lutin ->
      lutin
      |> String.split("\n", trim: true)
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
