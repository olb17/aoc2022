defmodule AdventOfCode.Day10 do
  def part1(args) do
    instr = parse(args)

    %{instr: instr, x: 1, cycle: 0, signal_strength: 0}
    |> loop(&collect_ss/1)
    |> Map.get(:signal_strength)
  end

  defp loop(%{instr: [{:addx, c, 0} | rest], x: x} = machine, part_fun) do
    %{machine | instr: rest, x: x + c} |> loop(part_fun)
  end

  defp loop(%{instr: [{:addx, c, ttl} | rest], cycle: cycle} = machine, part_fun) do
    %{machine | instr: [{:addx, c, ttl - 1} | rest], cycle: cycle + 1}
    |> part_fun.()
    |> loop(part_fun)
  end

  defp loop(%{instr: [:noop | rest], cycle: cycle} = machine, part_fun) do
    %{machine | instr: rest, cycle: cycle + 1} |> part_fun.() |> loop(part_fun)
  end

  defp loop(%{instr: []} = machine, _part_fun), do: machine

  defp collect_ss(%{x: x, cycle: cycle, signal_strength: ss} = machine)
       when rem(cycle - 20, 40) == 0 do
    %{machine | signal_strength: ss + x * cycle}
  end

  defp collect_ss(machine), do: machine

  defp parse(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn
      "addx " <> c -> {:addx, String.to_integer(c), 2}
      "noop" -> :noop
    end)
  end

  def part2(args) do
    IO.puts("")
    instr = parse(args)

    %{instr: instr, x: 1, cycle: 0, draw: ""}
    |> loop(&draw/1)
    |> Map.get(:draw)
    |> String.codepoints()
    |> Enum.chunk_every(40)
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.each(&IO.puts/1)
  end

  defp draw(%{x: x, cycle: cycle, draw: draw} = machine)
       when x - 1 <= rem(cycle - 1, 40) and rem(cycle - 1, 40) <= x + 1 do
    %{machine | draw: draw <> "#"}
  end

  defp draw(%{draw: draw} = machine) do
    %{machine | draw: draw <> "."}
  end
end
