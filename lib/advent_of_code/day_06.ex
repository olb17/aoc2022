defmodule AdventOfCode.Day06 do
  def part1(args), do: args |> parse(4)

  def parse(args, nb), do: args |> String.split("") |> process(nb, nb)

  def process(message, i, nb) do
    {[a | rest2], rest} = Enum.split(message, nb)
    if count_diff_chars([a | rest2]) == nb, do: i, else: process(rest2 ++ rest, i + 1, nb)
  end

  def count_diff_chars(array), do: array |> MapSet.new() |> MapSet.size()

  def part2(args), do: args |> parse(14)
end
