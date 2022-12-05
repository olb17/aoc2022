defmodule AdventOfCode.Day05 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(Map.new(), &process_lines/2)
    |> Enum.count(fn {_k, v} -> v >= 2 end)
  end

  def parse_line(line) do
    [point1, "->", point2] = String.split(line, " ", trim: true)

    [x1, y1] = String.split(point1, ",")
    [x2, y2] = String.split(point2, ",")

    {{String.to_integer(x1), String.to_integer(y1)},
     {String.to_integer(x2), String.to_integer(y2)}}
  end

  def process_lines({{x1, y1}, {x1, y2}}, loaded_points) do
    Enum.reduce(y1..y2, loaded_points, fn y, map ->
      Map.update(map, {x1, y}, 1, &(&1 + 1))
    end)
  end

  def process_lines({{x1, y1}, {x2, y1}}, loaded_points) do
    Enum.reduce(x1..x2, loaded_points, fn x, map ->
      Map.update(map, {x, y1}, 1, &(&1 + 1))
    end)
  end

  def process_lines(_, loaded_points), do: loaded_points

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(Map.new(), &process_diagonal/2)
    |> Enum.count(fn {_k, v} -> v >= 2 end)
  end

  def process_diagonal({{x1, y1}, {x1, y2}}, loaded_points) do
    Enum.reduce(y1..y2, loaded_points, fn y, map ->
      Map.update(map, {x1, y}, 1, &(&1 + 1))
    end)
  end

  def process_diagonal({{x1, y1}, {x2, y1}}, loaded_points) do
    Enum.reduce(x1..x2, loaded_points, fn x, map ->
      Map.update(map, {x, y1}, 1, &(&1 + 1))
    end)
  end

  def process_diagonal({{x1, y1}, {x2, y2}}, loaded_points) when x2 - x1 == y2 - y1 do
    Enum.reduce(0..(x2 - x1), loaded_points, fn increment, map ->
      Map.update(map, {x1 + increment, y1 + increment}, 1, &(&1 + 1))
    end)
  end

  def process_diagonal({{x1, y1}, {x2, y2}}, loaded_points) when x1 - x2 == y2 - y1 do
    Enum.reduce(0..(x2 - x1), loaded_points, fn increment, map ->
      Map.update(map, {x1 + increment, y1 - increment}, 1, &(&1 + 1))
    end)
  end

  def process_diagonal(_, loaded_points), do: loaded_points
end
