defmodule AdventOfCode.Day12 do
  def part1(args) do
    graph = make_graph(args)
    traverse(graph, ["start"], "start", []) |> Enum.count()
  end

  defp traverse(_graph, curr_path, "end", success_path) do
    [curr_path | success_path]
  end

  defp traverse(graph, curr_path, curr_node, success_path) do
    Map.get(graph, curr_node, [])
    |> Enum.filter(fn node ->
      cond do
        String.upcase(node) == node -> true
        Enum.member?(curr_path, node) -> false
        true -> true
      end
    end)
    |> Enum.reduce(success_path, fn next_node, acc ->
      traverse(graph, [next_node | curr_path], next_node, acc)
    end)
  end

  def part2(args) do
    graph = make_graph(args)

    traverse2(graph, ["start"], "start", false, [])
    |> Enum.count()
  end

  defp traverse2(_graph, curr_path, "end", _twice, success_path) do
    [curr_path | success_path]
  end

  defp traverse2(graph, curr_path, curr_node, twice, success_path) do
    Map.get(graph, curr_node, [])
    |> Enum.reduce([], fn node, acc ->
      case can_be_visited?(curr_path, node, twice) do
        {true, new_twice} ->
          [{node, new_twice} | acc]

        false ->
          acc
      end
    end)
    |> Enum.reduce(success_path, fn {next_node, new_twice}, acc ->
      traverse2(graph, [next_node | curr_path], next_node, new_twice, acc)
    end)
  end

  defp can_be_visited?(list, elt, twice) do
    cond do
      elt == "start" ->
        false

      String.upcase(elt) == elt ->
        {true, twice}

      true ->
        nb = Enum.filter(list, &(&1 == elt)) |> Enum.count()

        cond do
          nb == 0 -> {true, twice}
          !twice && nb == 1 -> {true, true}
          true -> false
        end
    end
  end

  def make_graph(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn line, acc ->
      [a, b] = String.split(line, "-")
      from_a = Map.get(acc, a, MapSet.new())
      from_b = Map.get(acc, b, MapSet.new())

      acc
      |> Map.put(a, MapSet.put(from_a, b))
      |> Map.put(b, MapSet.put(from_b, a))
    end)
  end
end
