defmodule AdventOfCode.Day07 do
  def part1(args) do
    {positions, min_candidate, max_candidate} = parse_args(args)

    min_candidate..max_candidate
    |> Enum.map(fn candidate ->
      Enum.reduce(positions, 0, fn {k, v}, acc -> abs(k - candidate) * v + acc end)
    end)
    |> Enum.min()
  end

  defp parse_args(args) do
    positions =
      args
      |> String.split("\n", trim: true)
      |> List.first()
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.frequencies()

    {min_candidate, max_candidate} = Map.keys(positions) |> Enum.min_max()
    {positions, min_candidate, max_candidate}
  end

  def part2(args) do
    {positions, min_candidate, max_candidate} = parse_args(args)

    min_candidate..max_candidate
    |> Enum.map(fn candidate ->
      Enum.reduce(positions, 0, fn {k, v}, acc ->
        (abs(k - candidate) + 1) * abs(k - candidate) / 2 * v + acc
      end)
    end)
    |> Enum.min()
    |> Kernel.trunc()
  end
end
