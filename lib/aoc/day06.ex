defmodule Aoc.Day06 do
  def part1(args) do
    initial_banks =
      args
      |> parse()

    loop(initial_banks, MapSet.new([initial_banks]))
    |> elem(0)
  end

  def part2(args) do
    initial_banks =
      args
      |> parse()

    seen = loop(initial_banks, MapSet.new([initial_banks])) |> elem(1)

    loop(seen, MapSet.new([seen]))
    |> elem(0)
  end

  def parse(input) do
    input
    |> String.split(~r/\s+/, trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def redistribute(banks) do
    max_bank = Enum.max_by(banks, & &1)
    index = Enum.find_index(banks, &(&1 == max_bank))
    size = Enum.count(banks)
    blocks = max_bank
    banks = List.replace_at(banks, index, 0)
    redistribute(banks, index + 1, blocks, size)
  end

  def redistribute(banks, _index, 0, _size), do: banks

  def redistribute(banks, index, blocks, size) when index >= size do
    redistribute(banks, 0, blocks, size)
  end

  def redistribute(banks, index, blocks, size) do
    banks = List.update_at(banks, index, &(&1 + 1))
    redistribute(banks, index + 1, blocks - 1, size)
  end

  def loop(banks, seen, cycle \\ 1) do
    new_banks = redistribute(banks)

    case MapSet.member?(seen, new_banks) do
      false -> loop(new_banks, MapSet.put(seen, new_banks), cycle + 1)
      true -> {cycle, new_banks}
    end
  end
end
