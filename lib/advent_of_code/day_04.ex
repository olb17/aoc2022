defmodule AdventOfCode.Day04 do
  def part1(args) do
    {draws, grids} = prepare_data(args)

    {:winner, draw, grid} =
      Enum.reduce_while(draws, {:no_winner, grids}, fn
        draw, {:no_winner, grids} ->
          case process_draw(draw, grids) do
            {:no_winner, _new_grids} = resp ->
              {:cont, resp}

            {:winner, grid, _grids} ->
              {:halt, {:winner, draw, grid}}
          end
      end)

    compute_winner(draw, grid)
  end

  defp prepare_data(args) do
    [draws_lines | grids_lines] = String.split(args, "\n")
    draws = String.split(draws_lines, ",", trim: true)

    grids =
      grids_lines
      |> Enum.chunk_by(fn el -> el == "" end)
      |> Enum.filter(fn el -> el != [""] end)
      |> Enum.map(fn grid -> build_grid(grid, [], []) end)

    {draws, grids}
  end

  defp compute_winner(draw, {_cols, lines}) do
    String.to_integer(draw) *
      (lines
       |> Enum.map(fn col -> col |> Enum.map(&String.to_integer/1) |> Enum.sum() end)
       |> Enum.sum())
  end

  defp process_draw(draw, grids) do
    grids =
      grids
      |> Enum.map(fn {cols, lines} ->
        cols = Enum.map(cols, fn elts -> Enum.filter(elts, fn elt -> elt != draw end) end)
        lines = Enum.map(lines, fn elts -> Enum.filter(elts, fn elt -> elt != draw end) end)
        {cols, lines}
      end)

    {winners, loosers} = remove_winning_grids(grids)

    case winners do
      [] -> {:no_winner, loosers}
      [grid | _] -> {:winner, grid, loosers}
    end
  end

  defp remove_winning_grids(grids) do
    Enum.split_with(grids, fn {cols, lines} ->
      Enum.find(cols, fn elt -> elt == [] end) != nil or
        Enum.find(lines, fn elt -> elt == [] end) != nil
    end)
  end

  defp build_grid([line | lines], [], []) do
    line = String.split(line, " ", trim: true)
    build_grid(lines, Enum.chunk_every(line, 1), [line])
  end

  defp build_grid([line_new | lines_new], cols, lines) do
    line = String.split(line_new, " ", trim: true)
    cols = build_cols(line, cols, [])
    build_grid(lines_new, cols, [line | lines])
  end

  defp build_grid([], cols, lines), do: {cols, lines}

  defp build_cols([col_new | cols_new], [col | cols], acc) do
    build_cols(cols_new, cols, [[col_new | col] | acc])
  end

  defp build_cols([], [], acc), do: Enum.reverse(acc)

  def part2(args) do
    {draws, grids} = prepare_data(args)

    {:winner, draw, grid} =
      Enum.reduce_while(draws, {:no_winner, grids}, fn
        draw, {:no_winner, grids} ->
          case process_draw(draw, grids) do
            {:no_winner, _new_grids} = resp ->
              {:cont, resp}

            {:winner, grid, grids} ->
              case grids do
                [] -> {:halt, {:winner, draw, grid}}
                grids -> {:cont, {:no_winner, grids}}
              end
          end
      end)

    compute_winner(draw, grid)
  end
end
