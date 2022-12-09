defmodule AdventOfCode.Day08 do
  def part1(args) do
    forest = parse_forest(args)
    {max_x, max_y} = forest_dim(forest)

    (for i <- 0..max_x do
       visible_trees_from(forest, i, 0, {0, 1}, -1, []) ++
         visible_trees_from(forest, i, max_y, {0, -1}, -1, [])
     end ++
       for j <- 0..max_y do
         visible_trees_from(forest, 0, j, {1, 0}, -1, []) ++
           visible_trees_from(forest, max_x, j, {-1, 0}, -1, [])
       end)
    |> Enum.concat()
    |> Enum.uniq()
    |> Enum.count()
  end

  def visible_trees_from(forest, x, y, {vx, vy} = dir, altitude, lower_trees)
      when is_map_key(forest, {x, y}) do
    if forest[{x, y}] <= altitude do
      visible_trees_from(forest, x + vx, y + vy, dir, altitude, lower_trees)
    else
      visible_trees_from(forest, x + vx, y + vy, dir, forest[{x, y}], [
        {x, y} | lower_trees
      ])
    end
  end

  def visible_trees_from(_forest, _row, _col, {_vx, _vy} = _dir, _altitude, lower_trees),
    do: lower_trees

  def parse_forest(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, i}, repo ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(repo, fn {tree, j}, repo2 ->
        Map.put(repo2, {i, j}, String.to_integer(tree))
      end)
    end)
  end

  def forest_dim(forest) do
    max_x = forest |> Map.keys() |> Enum.map(fn {x, _y} -> x end) |> Enum.max()
    max_y = div(Enum.count(forest), max_x + 1) - 1
    {max_x, max_y}
  end

  def part2(args) do
    forest = parse_forest(args)
    {max_x, max_y} = forest_dim(forest)

    for x <- 1..(max_x - 1), y <- 1..(max_y - 1) do
      scenic_score(forest, x, y)
    end
    |> Enum.max()
  end

  def scenic_score(forest, x, y) do
    scenic_score(forest, x - 1, y, {-1, 0}, forest[{x, y}], 0) *
      scenic_score(forest, x + 1, y, {1, 0}, forest[{x, y}], 0) *
      scenic_score(forest, x, y + 1, {0, 1}, forest[{x, y}], 0) *
      scenic_score(forest, x, y - 1, {0, -1}, forest[{x, y}], 0)
  end

  def scenic_score(forest, x, y, {vx, vy} = dir, altitude, score)
      when is_map_key(forest, {x, y}) do
    if altitude <= forest[{x, y}] do
      score + 1
    else
      scenic_score(forest, x + vx, y + vy, dir, altitude, score + 1)
    end
  end

  def scenic_score(_forest, _x, _y, {_vx, _vy} = _dir, _altitude, score), do: score
end
