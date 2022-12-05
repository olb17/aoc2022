defmodule AdventOfCode.Day03 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn rucksack ->
      rucksack
      |> split_rucksack()
      |> find_commmon_item()
      |> evaluate_common_item()
    end)
    |> Enum.sum()
  end

  def split_rucksack(rucksack) do
    items = String.split(rucksack, "", trim: true)
    Enum.split(items, floor(Enum.count(items) / 2))
  end

  def find_commmon_item({a, b}) do
    Enum.find(a, fn item ->
      Enum.find(b, &(&1 == item))
    end)
  end

  def find_commmon_item([a, b, c]) do
    Enum.concat([dedup_ruksack(a), dedup_ruksack(b), dedup_ruksack(c)])
    |> Enum.frequencies()
    |> Enum.find(fn {_item, freq} -> freq == 3 end)
    |> elem(0)
  end

  defp dedup_ruksack(ruksack) do
    ruksack
    |> String.split("", trim: true)
    |> Enum.uniq()
  end

  def evaluate_common_item(item) do
    [i] = String.to_charlist(item)

    cond do
      i >= 65 && i <= 90 -> i - 65 + 27
      i >= 97 && i <= 122 -> i - 97 + 1
    end
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.chunk_every(3)
    |> Enum.map(fn elves ->
      elves
      |> find_commmon_item()
      |> evaluate_common_item()
    end)
    |> Enum.sum()
  end
end
