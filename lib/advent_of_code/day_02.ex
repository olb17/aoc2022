defmodule AdventOfCode.Day02 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn match ->
      [a, b] = String.split(match, " ")

      price(transco(a), transco(b))
      |> elem(1)
    end)
    |> Enum.sum()
  end

  def price(a, a), do: {price(a) + 3, price(a) + 3}
  def price(:rock, :paper), do: {price(:rock), price(:paper) + 6}
  def price(:rock, :scissors), do: {price(:rock) + 6, price(:scissors)}
  def price(:paper, :scissors), do: {price(:paper), price(:scissors) + 6}

  def price(a, b) do
    {ra, rb} = price(b, a)
    {rb, ra}
  end

  def price(:rock), do: 1
  def price(:paper), do: 2
  def price(:scissors), do: 3

  def transco("A"), do: :rock
  def transco("X"), do: :rock
  def transco("B"), do: :paper
  def transco("Y"), do: :paper
  def transco("C"), do: :scissors
  def transco("Z"), do: :scissors

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn match ->
      [a, b] = String.split(match, " ")

      price(transco(a), transco2(a, b))
      |> elem(1)
    end)
    |> Enum.sum()
  end

  @loose %{"A" => :scissors, "B" => :rock, "C" => :paper}
  @win %{"B" => :scissors, "C" => :rock, "A" => :paper}
  def transco2(a, "Y"), do: transco(a)
  def transco2(a, "X"), do: Map.get(@loose, a)
  def transco2(a, "Z"), do: Map.get(@win, a)
end
