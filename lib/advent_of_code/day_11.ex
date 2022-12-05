defmodule AdventOfCode.Day11 do
  @incr [{-1, -1}, {-1, 0}, {-1, 1}, {0, 1}, {0, -1}, {1, -1}, {1, 0}, {1, 1}]
  @steps 100
  def part1(args) do
    octos = parse_args(args)

    {_, nb_flash} =
      Enum.reduce(1..@steps, {octos, 0}, fn _, {acc, nb_flash} ->
        {new_acc, new_nb_flash} = step(acc)
        {new_acc, nb_flash + new_nb_flash}
      end)

    nb_flash
  end

  def step(octos) do
    new_octos =
      octos
      |> Enum.map(fn {pos, {val, _state}} ->
        {pos, {val + 1, :no_flash}}
      end)
      |> Map.new()

    flash(new_octos, 0)
  end

  def flash(octos, nb_flash) do
    flashing_octos =
      octos
      |> Enum.filter(fn {_pos, {val, state}} -> state == :no_flash and val > 9 end)
      |> Enum.map(fn {pos, {_val, :no_flash}} -> {pos, {0, :flash}} end)

    new_octos =
      Enum.reduce(flashing_octos, octos, fn {k, v}, acc ->
        Map.put(acc, k, v)
      end)

    octos_updated_with_neighbours =
      flashing_octos
      |> Enum.reduce(new_octos, fn {{x, y}, _}, acc ->
        Enum.reduce(@incr, acc, fn {dx, dy}, new_acc ->
          {_, new_new_acc} =
            Map.get_and_update(new_acc, {x + dx, y + dy}, fn cur_value ->
              case cur_value do
                {val, :no_flash} -> {{val, :no_flash}, {val + 1, :no_flash}}
                # out of map
                nil -> :pop
                # already flashed
                default -> {default, default}
              end
            end)

          new_new_acc
        end)
      end)

    if Enum.count(flashing_octos) == 0 do
      {octos_updated_with_neighbours, nb_flash}
    else
      flash(octos_updated_with_neighbours, nb_flash + Enum.count(flashing_octos))
    end
  end

  def parse_args(args) do
    vals =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split("", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    for i <- 0..9, j <- 0..9 do
      {{i, j}, {vals |> Enum.at(i) |> Enum.at(j), :no_flash}}
    end
    |> Map.new()
  end

  def part2(args) do
    octos = parse_args(args)
    find_all(octos, 0)
  end

  def find_all(octos, steps) do
    {new_octos, _} = step(octos)

    if Enum.all?(new_octos, fn {_, {val, _}} -> val == 0 end) do
      steps + 1
    else
      find_all(new_octos, steps + 1)
    end
  end
end
