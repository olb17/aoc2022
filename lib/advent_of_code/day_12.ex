defmodule AdventOfCode.Day12 do
  def part1(args) do
    {map, start} = parse(args)

    #  %{{x,y} => {val, shortest_path_to_start}}
    dijkstra(map, %{start => {?z + 1, 0}})
    |> Enum.find(&(elem(&1, 1) |> elem(0) == ?a - 1))
    |> elem(1)
    |> elem(1)
  end

  def part2(args) do
    {map, start} = parse(args)

    #  %{{x,y} => {val, shortest_path_to_start}}
    dijkstra(map, %{start => {?z + 1, 0}})
    |> Enum.filter(&(elem(&1, 1) |> elem(0) <= ?a))
    |> Enum.map(&(elem(&1, 1) |> elem(1)))
    |> Enum.sort()
    |> hd
  end

  def dijkstra(map, shortest) do
    Enum.flat_map(shortest, fn {pos, {val, path_nb}} ->
      find_valued_neighbours(map, pos, val, path_nb)
    end)
    |> Enum.sort_by(&elem(&1, 2))
    |> case do
      [{pos, val, path_nb} | _] ->
        dijkstra(Map.delete(map, pos), Map.put(shortest, pos, {val, path_nb}))

      [] ->
        shortest
    end
  end

  # returns {x,y} => {val, shortest_path_to_start} or nil
  @neighbours [{-1, 0}, {+1, 0}, {0, -1}, {0, 1}]
  defp find_valued_neighbours(map, {x, y}, val, path_nb) do
    for {nx, ny} <- @neighbours, Map.get(map, {x + nx, y + ny}, 0) >= val - 1 do
      {{x + nx, y + ny}, Map.get(map, {x + nx, y + ny}), path_nb + 1}
    end
  end

  defp parse(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn {str, i} -> {String.to_charlist(str) |> Enum.with_index(), i} end)
    |> Enum.reduce({%{}, nil}, fn {line, i}, acc ->
      Enum.reduce(line, acc, fn {char, j}, {map, entry} ->
        case char do
          ?S -> {Map.put(map, {i, j}, ?a - 1), entry}
          ?E -> {Map.put(map, {i, j}, ?z + 1), {i, j}}
          _ -> {Map.put(map, {i, j}, char), entry}
        end
      end)
    end)
  end
end
