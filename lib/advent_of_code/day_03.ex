defmodule AdventOfCode.Day03 do
  use Bitwise

  def part1(args) do
    {codes, nb} =
      args
      |> String.split("\n", trim: true)
      |> Enum.with_index(1)
      |> Enum.reduce(nil, &sum_bits_for_all_lines/2)

    gamma = compute_indicator(codes, fn bit -> bit > nb / 2 end)
    epsilon = compute_indicator(codes, fn bit -> bit <= nb / 2 end)

    gamma * epsilon
  end

  defp sum_bits_for_all_lines({line, index}, nil) do
    {split_and_map(line), index}
  end

  defp sum_bits_for_all_lines({line, index}, {acc, _}) do
    {line
     |> split_and_map()
     |> Enum.zip(acc)
     |> Enum.map(fn {a, b} -> a + b end), index}
  end

  defp split_and_map(line) do
    line
    |> String.split("", trim: true)
    |> Enum.map(fn
      "0" -> 0
      "1" -> 1
    end)
  end

  defp compute_indicator(codes, condition) do
    codes
    |> Enum.map(fn bit -> if condition.(bit), do: "1", else: "0" end)
    |> Enum.join()
    |> Integer.parse(2)
    |> elem(0)
  end

  def part2(args) do
    lines = args |> String.split("\n", trim: true)

    compute_indicator2(lines, :oxygen) *
      compute_indicator2(lines, :co2)
  end

  defp compute_indicator2(lines, type) do
    lines
    |> find_value([], [], type)
    |> Integer.parse(2)
    |> elem(0)
  end

  defp find_value(["0" <> rest | lines], zeros, ones, type) do
    find_value(lines, zeros ++ [rest], ones, type)
  end

  defp find_value(["1" <> rest | lines], zeros, ones, type) do
    find_value(lines, zeros, ones ++ [rest], type)
  end

  defp find_value([], [], [one], _type), do: "1" <> one

  defp find_value([], [zero], [], _type), do: "0" <> zero

  defp find_value([""], _zeros, _ones, _type), do: ""

  defp find_value([], zeros, ones, :oxygen = type) do
    if Enum.count(ones) >= Enum.count(zeros) do
      "1" <> find_value(ones, [], [], type)
    else
      "0" <> find_value(zeros, [], [], type)
    end
  end

  defp find_value([], zeros, ones, :co2 = type) do
    if Enum.count(ones) < Enum.count(zeros) do
      "1" <> find_value(ones, [], [], type)
    else
      "0" <> find_value(zeros, [], [], type)
    end
  end
end
