defmodule AdventOfCode.Day05 do
  def part1(args) do
    process(args, &process_cm9000/2)
  end

  def part2(args) do
    process(args, &process_cm9001/2)
  end

  defp process_cm9000(instruction_line, positions) do
    process_instruction(instruction_line, positions, :cm9000)
  end

  defp process_cm9001(instruction_line, positions) do
    process_instruction(instruction_line, positions, :cm9001)
  end

  def process(args, machine) do
    [initial_positions, instructions] = String.split(args, "\n\n", trim: true)

    positions = get_positions(initial_positions)

    instructions
    |> String.split("\n", trim: true)
    |> Enum.reduce(positions, &machine.(&1, &2))
    |> get_top()
  end

  defp get_positions(lines) do
    lines
    |> String.split("\n")
    |> Enum.reverse()
    |> Enum.drop(1)
    |> Enum.map(fn line ->
      line
      |> String.split("")
      |> Enum.filter(&(&1 != ""))
      |> Enum.chunk_every(4)
      |> Enum.reduce({%{}, 1}, fn item, acc ->
        push(item, acc)
      end)
      |> elem(0)
    end)
    |> Enum.reduce(%{}, fn line, acc ->
      Enum.reduce(line, acc, fn {key, value}, repo ->
        Map.update(repo, key, [value], fn existing ->
          [value | existing]
        end)
      end)
    end)
  end

  defp get_top(positions) do
    max = Map.keys(positions) |> Enum.max()

    Enum.reduce(1..max, "", fn i, result ->
      result <> hd(positions[i])
    end)
  end

  defp process_instruction(instruction_line, positions, machine) do
    [nb, from, to] = line2instruction(instruction_line)

    {moved, rest} = Enum.split(positions[from], nb)
    moved = if machine == :cm9000, do: moved |> Enum.reverse(), else: moved

    positions
    |> Map.put(to, moved ++ positions[to])
    |> Map.put(from, rest)
  end

  defp line2instruction(instruction_line) do
    [_, nb, _, from, _, to] = String.split(instruction_line, " ")
    Enum.map([nb, from, to], &String.to_integer/1)
  end

  defp push(["[", letter, "]" | _], {repo, col}) do
    {Map.put(repo, col, letter), col + 1}
  end

  defp push(_, {repo, col}) do
    {repo, col + 1}
  end
end
