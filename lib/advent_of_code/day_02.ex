defmodule AdventOfCode.Day02 do
  def part1(args) do
    {pos, depth} = args |> String.split("\n", trim: true) |> Enum.reduce({0, 0}, &process_line/2)
    pos * depth
  end

  defp process_line("forward " <> n, {pos, depth}), do: {pos + String.to_integer(n), depth}
  defp process_line("down " <> n, {pos, depth}), do: {pos, depth + String.to_integer(n)}
  defp process_line("up " <> n, {pos, depth}), do: {pos, depth - String.to_integer(n)}

  def part2(args) do
    {pos, depth, _aim} =
      args |> String.split("\n", trim: true) |> Enum.reduce({0, 0, 0}, &process_line2/2)

    pos * depth
  end

  defp process_line2("down " <> n, {pos, depth, aim}),
    do: {pos, depth, aim + String.to_integer(n)}

  defp process_line2("up " <> n, {pos, depth, aim}), do: {pos, depth, aim - String.to_integer(n)}

  defp process_line2("forward " <> n, {pos, depth, aim}),
    do: {pos + String.to_integer(n), depth + aim * String.to_integer(n), aim}
end
