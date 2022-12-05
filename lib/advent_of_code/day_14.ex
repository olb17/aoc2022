defmodule AdventOfCode.Day14 do
  def part1(args) do
    answer(args, 10)
  end

  def part2(args) do
    answer(args, 40)
  end

  def answer(args, steps) do
    [template_s, rules_s] = args |> String.split("\n\n", trim: true)

    rules =
      rules_s
      |> String.split("\n", trim: true)
      |> Enum.map(fn rule ->
        [pair, _, elt] = rule |> String.split(" ", trim: true)
        [left, right] = String.split(pair, "", trim: true)
        {pair, {left <> elt, elt <> right}}
      end)
      |> Map.new()

    polymer =
      template_s
      |> String.split("", trim: true)
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [left, right] -> {left <> right, 1} end)
      |> conso_pairs_into_map()
      |> IO.inspect(label: "23")

    final_polymer =
      Enum.reduce(1..steps, polymer, fn _, polymer ->
        polymer
        |> Enum.filter(fn {_pair, v} -> v > 0 end)
        |> Enum.flat_map(fn {pair, v} ->
          {left, right} = Map.fetch!(rules, pair)
          [{left, v}, {right, v}]
        end)
        |> conso_pairs_into_map()
      end)

    {{_, min}, {_, max}} =
      final_polymer
      |> Enum.filter(fn {_pair, v} -> v > 0 end)
      |> Enum.flat_map(fn {pair, val} ->
        [left, right] = String.split(pair, "", trim: true)
        [{left, val}, {right, val}]
      end)
      |> conso_pairs_into_map(%{
        String.slice(template_s, 0..0) => 1,
        String.slice(template_s, -1..-1) => 1
      })
      |> Enum.min_max_by(fn {_, val} -> val end)

    div(max - min, 2)
  end

  defp conso_pairs_into_map(pairs, initial_map \\ %{}) do
    Enum.reduce(pairs, initial_map, fn {pair, nb}, acc ->
      {_, acc} =
        Map.get_and_update(acc, pair, fn curr ->
          case curr do
            nil -> {nil, nb}
            _ -> {curr, curr + nb}
          end
        end)

      acc
    end)
  end
end
