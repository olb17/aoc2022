defmodule AdventOfCode.Day06 do
  @nb_days 80

  @nb_days_part2 256

  def part1(args, nb_days \\ @nb_days) do
    args |> parse_args() |> simulate_days(nb_days) |> Enum.count()
  end

  defp simulate_days(population, 0), do: population

  defp simulate_days(population, days) do
    {new_population, nb_new_borns} =
      Enum.reduce(population, {[], 0}, fn
        0, {new_pop, nb} -> {[6 | new_pop], nb + 1}
        age, {new_pop, nb} -> {[age - 1 | new_pop], nb}
      end)

    (List.duplicate(8, nb_new_borns) ++ new_population)
    |> Enum.reverse()
    |> simulate_days(days - 1)
  end

  defp parse_args(args) do
    args
    |> String.split("\n", trim: true)
    |> List.first()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part2(args) do
    args
    |> parse_args()
    |> Enum.frequencies()
    |> simulate_day2(@nb_days_part2)
    |> Map.values()
    |> Enum.sum()
  end

  def simulate_day2(map, 0), do: map

  def simulate_day2(map, day) do
    Enum.reduce(0..8, Map.new(), fn fish, new_map ->
      new_fish = rem(fish + 8, 9)
      Map.put(new_map, new_fish, Map.get(map, fish, 0))
    end)
    |> Map.update(6, 0, fn elt -> elt + Map.get(map, 0, 0) end)
    |> simulate_day2(day - 1)
  end
end
