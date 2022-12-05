defmodule AdventOfCode.Day15 do
  @neighbours [{1, 0}, {0, 1}, {-1, 0}, {0, -1}]

  def part1(args) do
    {grid, width, height} = get_tile(args)
    target = {width - 1, height - 1}

    find_costs(%{{0, 0} => 0}, MapSet.new([{0, 0}]), grid, target)
  end

  defp find_costs(costs, burned, grid, target) do
    Enum.count(burned) |> IO.inspect(label: "27")

    if Map.keys(grid) |> Enum.all?(fn elt -> MapSet.member?(burned, elt) end) do
      Map.get(costs, target)
    else
      {{x, y}, v} =
        costs
        |> Enum.filter(fn {k, _v} -> not MapSet.member?(burned, k) end)
        |> Enum.min_by(fn {_k, v} -> v end, fn -> {{0, 0}, 0} end)

      @neighbours
      |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
      |> Enum.filter(fn k -> Map.has_key?(grid, k) end)
      |> Enum.reduce(costs, fn elt, acc ->
        cost_neighbour = Map.get(grid, elt)

        case Map.get(acc, elt) do
          nil ->
            Map.put(acc, elt, v + cost_neighbour)

          val ->
            new_v = Enum.min([v + cost_neighbour, val])
            Map.put(acc, elt, new_v)
        end
      end)
      |> find_costs(MapSet.put(burned, {x, y}), grid, target)
    end
  end

  defp get_tile(args) do
    grid_str =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(fn line -> String.split(line, "", trim: true) end)

    height = Enum.count(grid_str)
    width = Enum.count(Enum.at(grid_str, 0))

    grid =
      for y <- 0..(height - 1),
          x <- 0..(width - 1),
          into: %{},
          do: {{x, y}, grid_str |> Enum.at(y) |> Enum.at(x) |> String.to_integer()}

    {grid, width, height}
  end

  def part2_naive(args) do
    {tile, width, height} = get_tile(args)

    grid =
      tile
      |> Enum.reduce(%{}, fn {{x, y}, v}, acc ->
        news =
          for i <- 0..4,
              j <- 0..4,
              into: %{},
              do: {{x + i * width, y + j * height}, rem(v + i + j - 1, 9) + 1}

        Map.merge(acc, news)
      end)

    Enum.count(grid) |> IO.inspect(label: "74")
    target = {5 * width - 1, 5 * height - 1}

    find_costs(%{{0, 0} => 0}, MapSet.new([{0, 0}]), grid, target)
  end

  def part2(args) do
    {tile, width, height} = get_tile(args)

    tile_neighbours =
      tile
      |> Enum.map(fn {{x, y}, _v} ->
        {{x, y},
         @neighbours
         |> Enum.map(fn {dx, dy} ->
           neighbour = {x + dx, y + dy}
           {neighbour, Map.get(tile, neighbour)}
         end)
         |> Enum.filter(fn {k, _v} -> Map.has_key?(tile, k) end)}
      end)
      |> Map.new()

    Map.get(tile_neighbours, {0, 0}) |> IO.inspect(label: "95")

    size = {width, height}

    reduced_tiles =
      1..8
      |> Stream.flat_map(fn i ->
        derived_tile = compute_derived_tile(tile_neighbours, size, i)

        for(j <- 0..(width - 1), do: {i, {j, 0}, derived_tile}) ++
          for(j <- 0..(width - 1), do: {i, {j, height - 1}, derived_tile}) ++
          for(k <- 1..(height - 2), do: {i, {0, k}, derived_tile}) ++
          for k <- 1..(height - 2), do: {i, {width - 1, k}, derived_tile}
      end)
      |> Task.async_stream(fn {i, origin, tile} ->
        {i, find_costs2(%{origin => 0}, MapSet.new([origin]), tile, origin, size)}
      end)
      |> Enum.reduce(%{}, fn {:ok, {i, {origin, costs}}}, acc ->
        {i, origin}
        map = %{origin => costs}
        map_i = Map.get(acc, i, %{})

        Map.put(acc, i, Map.merge(map_i, map))
      end)

    #
    reduced_tiles = Map.put(reduced_tiles, 0, tile_neighbours)

    unstiched_tiles =
      for i <- 0..4,
          j <- 0..4,
          {{x, y}, neighbours} <- Map.get(reduced_tiles, i + j),
          into: %{},
          do:
            {{x + i * width, y + j * height},
             Enum.map(neighbours, fn {{x_n, y_n}, cost} ->
               {{x_n + i * width, y_n + j * height}, cost}
             end)}

    stiching_pos =
      for(
        i <- 1..4,
        j <- 0..4,
        k <- 0..(height - 1),
        do:
          {{i * width - 1, j * height + k}, {i * width, j * height + k},
           tile |> Map.get({width - 1, k}), tile |> Map.get({0, k})}
      ) ++
        for(
          i <- 0..4,
          j <- 1..4,
          k <- 0..(width - 1),
          do:
            {{i * width + k, j * height - 1}, {i * width + k, j * height},
             tile |> Map.get({k, height - 1}), tile |> Map.get({k, height})}
        )

    stiched_tiles =
      Enum.reduce(stiching_pos, unstiched_tiles, fn {from, to, cost_from, cost_to}, acc ->
        neighbours_from = Map.get(acc, from) ++ [{to, cost_to}]
        neighbours_to = Map.get(acc, to) ++ [{from, cost_from}]
        acc |> Map.put(to, neighbours_to) |> Map.put(from, neighbours_from)
      end)

    stiched_tiles
    |> Enum.each(fn {k, neighbours} ->
      neighbours |> Enum.filter(fn {_node, v} -> v == 0 end) |> IO.inspect(label: "161")
    end)

    Enum.count(stiched_tiles) |> IO.inspect(label: "127")

    origin = {0, 0}
    target = {width * 5 - 1, height * 5 - 1}
    # find_costs2(%{origin => 0}, MapSet.new([origin]), stiched_tiles, origin, target, true)
  end

  defp compute_derived_tile(tile, {width, height}, i) do
    for x <- 0..(width - 1),
        y <- 0..(height - 1),
        into: %{},
        do:
          {{x, y},
           tile
           |> Map.get({x, y})
           |> Enum.map(fn {pos, val} ->
             {pos, rem(val + i - 1, 9) + 1}
           end)}
  end

  defp find_costs2(costs, burned, grid, origin, {width, height}, debug \\ false) do
    if debug, do: Enum.count(burned) |> IO.inspect(label: "27")

    if Map.keys(grid) |> Enum.all?(fn elt -> MapSet.member?(burned, elt) end) do
      {origin,
       costs
       |> Enum.filter(fn {{x, y}, _v} ->
         (x == 0 || y == 0 || x == width - 1 || y == height - 1) &&
           {x, y} != {width - 1, height - 1}
       end)}
    else
      {{x, y}, v} =
        costs
        |> Enum.filter(fn {k, _v} -> not MapSet.member?(burned, k) end)
        |> Enum.min_by(fn {_k, v} -> v end, fn -> {origin, 0} end)

      if debug, do: {{x, y}, v} |> IO.inspect(label: "194")

      grid
      |> Map.get({x, y})
      |> Enum.reduce(costs, fn {elt, cost_neighbour}, acc ->
        if debug, do: acc |> IO.inspect(label: "199")

        case Map.get(acc, elt) do
          nil ->
            Map.put(acc, elt, v + cost_neighbour)

          val ->
            new_v = Enum.min([v + cost_neighbour, val])
            Map.put(acc, elt, new_v)
        end
      end)
      |> find_costs2(MapSet.put(burned, {x, y}), grid, origin, {width, height})
    end
  end
end
