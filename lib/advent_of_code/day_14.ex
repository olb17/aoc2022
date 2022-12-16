defmodule AdventOfCode.Day14 do
  def part1(args) do
    cave = parse(args)
    abyss = min_heigth(cave) + 1

    Stream.iterate(0, &(&1 + 1))
    |> Stream.map(&{500, 0, &1})
    |> Enum.reduce_while(cave, fn sand_pos, cave ->
      {cave, fallen, i} = sand_fall(sand_pos, cave, abyss)
      if fallen, do: {:halt, i}, else: {:cont, cave}
    end)
  end

  def part2(args) do
    cave = parse(args)
    floor = min_heigth(cave) + 1

    Stream.iterate(1, &(&1 + 1))
    |> Stream.map(&{500, 0, &1})
    |> Enum.reduce_while(cave, fn sand_pos, cave ->
      {cave, _fallen, i} = sand_fall(sand_pos, cave, floor)
      if Map.has_key?(cave, {500, 0}), do: {:halt, i}, else: {:cont, cave}
    end)
  end

  defp min_heigth(cave) do
    cave
    |> Map.keys()
    |> Enum.map(&elem(&1, 1))
    |> Enum.max()
  end

  def sand_fall({x, y, i}, cave, bottom) when y < bottom do
    cond do
      not Map.has_key?(cave, {x, y + 1}) ->
        sand_fall({x, y + 1, i}, cave, bottom)

      not Map.has_key?(cave, {x - 1, y + 1}) ->
        sand_fall({x - 1, y + 1, i}, cave, bottom)

      not Map.has_key?(cave, {x + 1, y + 1}) ->
        sand_fall({x + 1, y + 1, i}, cave, bottom)

      true ->
        {Map.put(cave, {x, y}, "o"), false, i}
    end
  end

  def sand_fall({x, y, i}, cave, _bottom), do: {Map.put(cave, {x, y}, "o"), true, i}

  defp parse(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn path, cave ->
      path
      |> parse_path()
      |> draw_line(cave)
    end)
  end

  defp draw_line([[x, y], [x, z] | rest], cave) do
    cave =
      for i <- y..z, reduce: cave do
        acc ->
          Map.put(acc, {x, i}, "#")
      end

    draw_line([[x, z] | rest], cave)
  end

  defp draw_line([[x, y], [z, y] | rest], cave) do
    cave =
      for i <- x..z, reduce: cave do
        acc ->
          Map.put(acc, {i, y}, "#")
      end

    draw_line([[z, y] | rest], cave)
  end

  defp draw_line([_], cave) do
    cave
  end

  defp parse_path(path) do
    path
    |> String.split(" -> ", trim: true)
    |> Enum.map(fn coord -> String.split(coord, ",") |> Enum.map(&String.to_integer/1) end)
  end
end
