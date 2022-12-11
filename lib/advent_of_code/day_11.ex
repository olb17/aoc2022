defmodule AdventOfCode.Day11 do
  def part1(args) do
    [first, second] =
      parse_monkeys(args)
      |> monkey_play(20, 3)

    first * second
  end

  def part2(args) do
    [first, second] =
      parse_monkeys(args)
      |> monkey_play(10000, 1)

    first * second
  end

  defp monkey_play(monkeys, rounds, worry_div) do
    # optim for part 2
    divisible =
      monkeys
      |> Enum.map(&elem(&1, 1).divisible)
      |> Enum.reduce(1, &(&1 * &2))

    1..rounds
    |> Enum.reduce(monkeys, fn _i, monkeys ->
      monkeys =
        0..(length(Map.keys(monkeys)) - 1)
        |> Enum.reduce(monkeys, fn i, monkeys ->
          monkey = monkeys[i]

          monkeys =
            monkey.items
            |> Enum.reduce(monkeys, fn item, monkeys ->
              ope_f = monkey.operation
              to_f = monkey.to
              worry = Integer.floor_div(ope_f.(item), worry_div)
              to = to_f.(worry)
              worry = rem(worry, divisible)
              Map.put(monkeys, to, %{monkeys[to] | items: monkeys[to].items ++ [worry]})
            end)

          monkey = %{monkey | items: [], activity: monkey.activity + length(monkey.items)}

          Map.put(monkeys, i, monkey)
        end)

      monkeys
    end)
    |> Enum.map(&elem(&1, 1).activity)
    |> Enum.sort(:desc)
    |> Enum.take(2)
  end

  defp parse_monkeys(args) do
    args
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_monkey/1)
    |> Enum.map(&{&1.id, &1})
    |> Map.new()
  end

  @regex ~r/Monkey (?<id>[[:digit:]]+).*\n.*Starting items: (?<items>((, )?[[:digit:]]+)+).*\n.*Operation: new = old (?<operation>.*).*\n.*Test: divisible by (?<divisible>[[:digit:]]+).*\n.*If true: throw to monkey (?<to_true>[[:digit:]]+).*\n.*If false: throw to monkey (?<to_false>[[:digit:]]+)/m
  defp parse_monkey(lines) do
    m = Regex.named_captures(@regex, lines, all_but_first: true)

    %{
      id: String.to_integer(m["id"]),
      items: parse_int_list(m["items"]),
      operation: parse_operation(m["operation"]),
      divisible: String.to_integer(m["divisible"]),
      to: parse_divisible(m["divisible"], m["to_true"], m["to_false"]),
      activity: 0
    }
  end

  defp parse_divisible(str, t, f) do
    i = String.to_integer(str)
    t_i = String.to_integer(t)
    f_i = String.to_integer(f)
    &if rem(&1, i) == 0, do: t_i, else: f_i
  end

  defp parse_int_list(list) do
    list |> String.split(", ") |> Enum.map(&String.to_integer/1)
  end

  defp parse_operation("+ " <> str) do
    i = String.to_integer(str)
    &(&1 + i)
  end

  defp parse_operation("* old"), do: &(&1 * &1)

  defp parse_operation("* " <> str) do
    i = String.to_integer(str)
    &(&1 * i)
  end
end
