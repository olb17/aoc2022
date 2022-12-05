defmodule AdventOfCode.Day16 do
  def part1(args) do
    data =
      args
      |> text2bits()

    {_data, versions, _value} = parse(data, [])
    Enum.sum(versions)
  end

  defp text2bits(args) do
    [value] = String.split(args, "\n", trim: true)

    value
    |> String.split("", trim: true)
    |> Enum.reduce(<<>>, fn c, acc ->
      {i, _} = Integer.parse(c, 16)
      <<acc::bitstring, i::4>>
    end)
  end

  defp parse(<<>>, versions) do
    [{<<>>, versions, 0}]
  end

  defp parse(data, versions) do
    <<version::little-3, type::little-3, data::bitstring>> = data
    # "Parsing version:#{version} type:#{type} data:#{inspect(data)}" |> IO.inspect(label: "27")
    parse(type, data, [version | versions])
  end

  defp parse(4, data, versions) do
    #   "literal #{inspect(data)}" |> IO.inspect(label: "24")
    parse_literal(data, versions, <<>>, 1)
  end

  defp parse(_op, <<0::1, length::15, data::bitstring>>, versions) do
    #  "op length" |> IO.inspect(label: "34")
    <<data::size(length), rest::bitstring>> = data
    {<<>>, versions, value} = parse_blocks(<<data::size(length)>>, versions)
    {rest, versions, value}
  end

  defp parse(_op, <<1::1, nb_subpackets::11, data::bitstring>>, versions) do
    # "op packets #{nb_subpackets}" |> IO.inspect(label: "33")
    parse_packets(data, versions, nb_subpackets)
  end

  defp parse_packets(data, versions, 0) do
    {data, versions}
  end

  defp parse_packets(data, versions, nb_subpackets) do
    {data, versions, value} = parse(data, versions)
    parse_packets(data, versions, nb_subpackets - 1)
  end

  defp parse_blocks(<<>>, versions) do
    {<<>>, versions, 0}
  end

  defp parse_blocks(data, versions) do
    {data, versions, _value} = parse(data, versions)
    parse_blocks(data, versions)
  end

  defp parse_literal(<<1::1, bits::4, data::bitstring>>, versions, acc, nb_4bits) do
    parse_literal(data, versions, <<acc::bitstring, bits::4>>, nb_4bits + 1)
  end

  defp parse_literal(<<0::1, bits::4, data::bitstring>>, versions, acc, nb_4bits) do
    length = nb_4bits * 4
    <<value::size(length)>> = <<acc::bitstring, bits::4>>
    {data, versions, value}
  end

  def part2(args) do
  end
end
