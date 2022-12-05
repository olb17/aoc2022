defmodule AdventOfCode.Day13 do
  def part1(args) do
    [dots, instr] = String.split(args, "\n\n", trim: true)

    dots =
      dots
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [x, y] = String.split(line, ",")
        {{String.to_integer(x), String.to_integer(y)}, "x"}
      end)
      |> Map.new()

    ["fold along " <> dimension, fold] =
      String.split(instr, "\n", trim: true)
      |> hd
      |> String.split("=")

    fold(dimension, String.to_integer(fold), dots)
    |> Enum.count()
  end

  def fold("x", fold, dots) do
    {unfolded, folded} = Enum.split_with(dots, fn {{x, _y}, _} -> x < fold end)

    (unfolded ++ Enum.map(folded, fn {{x, y}, v} -> {{fold - (x - fold), y}, v} end))
    |> Map.new()
  end

  def fold("y", fold, dots) do
    {unfolded, folded} = Enum.split_with(dots, fn {{_x, y}, _} -> y < fold end)

    (unfolded ++ Enum.map(folded, fn {{x, y}, v} -> {{x, fold - (y - fold)}, v} end))
    |> Map.new()
  end

  def part2(args) do
    [dots_str, instr] = String.split(args, "\n\n", trim: true)

    dots =
      dots_str
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [x, y] = String.split(line, ",")
        {{String.to_integer(x), String.to_integer(y)}, "x"}
      end)
      |> Map.new()

    dots =
      instr
      |> String.split("\n", trim: true)
      |> Enum.reduce(dots, fn instr, acc ->
        ["fold along " <> dimension, fold] = String.split(instr, "=")
        fold(dimension, String.to_integer(fold), acc)
      end)

    {minx, maxx} = Map.keys(dots) |> Enum.map(&elem(&1, 0)) |> Enum.min_max()

    {miny, maxy} = Map.keys(dots) |> Enum.map(&elem(&1, 1)) |> Enum.min_max()

    IO.puts("")

    for y <- miny..maxy do
      for x <- minx..maxx do
        IO.write(Map.get(dots, {x, y}, " "))
      end

      IO.puts("")
    end

    IO.puts("")
  end
end
