defmodule AdventOfCode.Day09 do
  def part1(args) do
    parse_args(args)
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.reduce([], fn lines, low_points ->
      find_low_points(lines, low_points)
    end)
    |> Enum.map(fn val -> val + 1 end)
    |> Enum.sum()
  end

  def find_low_points([[_a1, _b1], [_a2, _b2], [_a3, _b3]], low_points) do
    low_points
  end

  def find_low_points(
        [[_a1, b1, c1 | rest1], [a2, b2, c2 | rest2], [_a3, b3, c3 | rest3]],
        low_points
      )
      when b2 < a2 and b2 < c2 and b2 < b1 and b2 < b3 do
    find_low_points([[b1, c1 | rest1], [b2, c2 | rest2], [b3, c3 | rest3]], [b2 | low_points])
  end

  def find_low_points(
        [[_a1, b1, c1 | rest1], [_a2, b2, c2 | rest2], [_a3, b3, c3 | rest3]],
        low_points
      ) do
    find_low_points([[b1, c1 | rest1], [b2, c2 | rest2], [b3, c3 | rest3]], low_points)
  end

  defp parse_args(args) do
    lines =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(&String.trim/1)
      |> Enum.map(fn line ->
        [11] ++
          (line
           |> String.split("", trim: true)
           |> Enum.map(&String.to_integer/1)) ++
          [11]
      end)

    # height = Enum.count(lines)
    width = Enum.at(lines, 0) |> Enum.count()
    fake_line = List.duplicate(11, width)

    [fake_line] ++ lines ++ [fake_line]
  end

  def part2(args) do
    width =
      args
      |> String.split("\n", trim: true)
      |> Enum.at(0)
      |> String.trim()
      |> String.length()

    positions =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(&String.trim/1)
      |> Enum.with_index(1)
      |> Enum.reduce(Map.new(), fn {chars, line}, positions ->
        chars
        |> String.split("", trim: true)
        |> Enum.map(&String.to_integer/1)
        |> Enum.with_index(1)
        |> Enum.reduce(positions, fn {val, col}, positions ->
          Map.put(positions, {line, col}, val)
        end)
      end)

    height = div(Enum.count(positions), width)

    # add borders with 11
    positions =
      Enum.concat([
        for(col <- 0..(width + 1), do: {0, col}),
        for(col <- 0..(width + 1), do: {height + 1, col}),
        for(line <- 0..(height + 1), do: {line, 0}),
        for(line <- 0..(height + 1), do: {line, width + 1})
      ])
      |> Enum.reduce(positions, fn point, acc ->
        Map.put(acc, point, 11)
      end)

    candidates = for col <- 1..width, line <- 1..height, do: {line, col}

    candidates
    |> Enum.filter(fn pos -> is_low(positions, pos) end)
    |> Enum.map(fn low -> find_basin(positions, MapSet.new([low])) end)
    |> Enum.uniq()
    |> Enum.map(&MapSet.size/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()

    # 1442897
  end

  def find_basin(positions, lows) do
    new_lows =
      Enum.reduce(MapSet.to_list(lows), lows, fn {x, y}, acc ->
        acc
        |> add_to_lows({x - 1, y}, positions)
        |> add_to_lows({x + 1, y}, positions)
        |> add_to_lows({x, y - 1}, positions)
        |> add_to_lows({x, y + 1}, positions)
      end)

    if new_lows == lows do
      lows
    else
      find_basin(positions, new_lows)
    end
  end

  def add_to_lows(lows, point, positions) do
    if Map.get(positions, point) >= 9 do
      lows
    else
      MapSet.put(lows, point)
    end
  end

  def is_low(positions, {col, line}) do
    up = Map.get(positions, {col, line - 1})
    down = Map.get(positions, {col, line + 1})
    left = Map.get(positions, {col - 1, line})
    right = Map.get(positions, {col + 1, line - 1})
    val = Map.get(positions, {col, line})

    val < up and val < down and val < left and val < right
  end
end
