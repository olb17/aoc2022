defmodule AdventOfCode.Day10 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
      |> score_line([], true)
    end)
    |> Enum.sum()
  end

  def score_line([], [], _), do: 0
  def score_line([], _, true), do: 0
  def score_line([], stack, false), do: {:incomplete, stack}

  def score_line([char | rest], stack, flag) when char in ["(", "[", "{", "<"] do
    score_line(rest, [char | stack], flag)
  end

  def score_line([")" | rest], ["(" | stack], flag), do: score_line(rest, stack, flag)
  def score_line(["]" | rest], ["[" | stack], flag), do: score_line(rest, stack, flag)
  def score_line(["}" | rest], ["{" | stack], flag), do: score_line(rest, stack, flag)
  def score_line([">" | rest], ["<" | stack], flag), do: score_line(rest, stack, flag)

  def score_line([")" | _rest], _, _), do: 3
  def score_line(["]" | _rest], _, _), do: 57
  def score_line(["}" | _rest], _, _), do: 1197
  def score_line([">" | _rest], _, _), do: 25137

  def part2(args) do
    resp =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(fn line -> String.split(line, "", trim: true) end)
      |> Enum.map(fn line ->
        case score_line(line, [], false) do
          {:incomplete, stack} -> stack
          _ -> nil
        end
      end)
      |> Enum.filter(&(&1 != nil))
      |> Enum.map(fn stack -> stack |> score_autocomplete(0) end)
      |> Enum.sort()

    Enum.at(resp, div(Enum.count(resp), 2))
  end

  def score_autocomplete([], value), do: value
  def score_autocomplete(["(" | rest], value), do: score_autocomplete(rest, 5 * value + 1)
  def score_autocomplete(["[" | rest], value), do: score_autocomplete(rest, 5 * value + 2)
  def score_autocomplete(["{" | rest], value), do: score_autocomplete(rest, 5 * value + 3)
  def score_autocomplete(["<" | rest], value), do: score_autocomplete(rest, 5 * value + 4)
end
