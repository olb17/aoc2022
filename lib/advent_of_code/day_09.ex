defmodule AdventOfCode.Day09 do
  def part1(args) do
    args
    |> parse_instr()
    |> Enum.reduce({[{0, 0}, {0, 0}], []}, fn {dir, nb}, {[head, tail], t_pos} ->
      1..nb
      |> Enum.reduce({[head, tail], t_pos}, fn _i, {[head, tail], t_pos} ->
        new_head = move_head(head, dir)
        new_tail = move_tail(new_head, tail)
        {[new_head, new_tail], [new_tail | t_pos]}
      end)
    end)
    |> elem(1)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp move_head({h_x, h_y}, "R"), do: {h_x + 1, h_y}
  defp move_head({h_x, h_y}, "L"), do: {h_x - 1, h_y}
  defp move_head({h_x, h_y}, "U"), do: {h_x, h_y + 1}
  defp move_head({h_x, h_y}, "D"), do: {h_x, h_y - 1}

  defp move_tail({h_x, h_y}, {t_x, h_y}) when abs(h_x - t_x) > 1 do
    {t_x + div(h_x - t_x, abs(h_x - t_x)), h_y}
  end

  defp move_tail({h_x, h_y}, {h_x, t_y}) when abs(h_y - t_y) > 1 do
    {h_x, t_y + div(h_y - t_y, abs(h_y - t_y))}
  end

  defp move_tail({h_x, h_y}, {t_x, t_y}) when abs(h_y - t_y) > 1 or abs(h_x - t_x) > 1 do
    {t_x + div(h_x - t_x, abs(h_x - t_x)), t_y + div(h_y - t_y, abs(h_y - t_y))}
  end

  defp move_tail(_çhead, tail), do: tail

  defp parse_instr(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [dir, nb] = String.split(line, " ", trim: true)
      {dir, String.to_integer(nb)}
    end)
  end

  @spec part2(any) :: any
  def part2(args) do
    snake = for(_i <- 1..10, do: {10, 10})

    args
    |> parse_instr()
    |> Enum.reduce({snake, []}, fn {dir, nb}, {snake, t_pos} ->
      1..nb
      |> Enum.reduce({snake, t_pos}, fn _i, {[head | tail], t_pos} ->
        new_head = move_head(head, dir)
        [node_9 | rest] = move_snake(new_head, tail, [])
        {[new_head | [node_9 | rest] |> Enum.reverse()], [node_9 | t_pos]}
      end)
    end)
    |> elem(1)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp move_snake(head, [tail1 | tail], after_tail) do
    new_tail = move_tail(head, tail1)
    move_snake(new_tail, tail, [new_tail | after_tail])
  end

  defp move_snake(_head, [], after_tail), do: after_tail

  defp print_snake(snake) do
    IO.puts("")

    value_snake = snake |> Enum.with_index() |> Enum.reverse() |> Map.new()

    playground =
      for i <- 0..20, j <- 0..26, into: %{} do
        {{i, j}, "."}
      end
      |> Map.merge(value_snake)

    for i <- 0..20 do
      for j <- 0..26, do: IO.write(playground[{i, j}])
      IO.puts("")
    end

    snake
  end
end
