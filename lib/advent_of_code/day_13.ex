defmodule AdventOfCode.Day13 do
  def part1(args) do
    args
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn pairs ->
      [left, right] = pairs |> String.split("\n", trim: true)
      {left |> parse_line(), right |> parse_line()}
    end)
    |> Enum.map(fn {left, right} -> compare(left, right) end)
    |> Enum.with_index()
    |> Enum.map(fn
      {true, i} -> i + 1
      {false, _i} -> 0
    end)
    |> Enum.sum()
  end

  defp compare(a, a) when is_integer(a), do: true
  defp compare([], []), do: nil
  defp compare([_ | _], []), do: false
  defp compare([], [_ | _]), do: true
  defp compare(a, b) when is_integer(a) and is_integer(b), do: a < b

  defp compare(a, b) when is_integer(a) and is_list(b), do: compare([a], b)
  defp compare(a, b) when is_integer(b) and is_list(a), do: compare(a, [b])
  defp compare([a | resta], [a | restb]), do: compare(resta, restb)

  defp compare([a | resta], [b | restb]) do
    res = compare(a, b)
    if res != nil, do: res, else: compare(resta, restb)
  end

  @div1 [[2]]
  @div2 [[6]]
  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn str -> str |> String.trim() |> parse_line end)
    |> Kernel.++([@div1, @div2])
    |> Enum.sort_by(& &1, &compare/2)
    |> Enum.with_index()
    |> Enum.flat_map(fn {elt, i} ->
      if elt == @div1 or elt == @div2 do
        [i + 1]
      else
        []
      end
    end)
    |> Enum.product()
  end

  def parse_line(str), do: Code.eval_string(str) |> elem(0)
end
