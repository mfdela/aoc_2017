defmodule Aoc.Day10 do
  def part1(args, size \\ 256) do
    list = for i <- 0..(size - 1), do: i

    args
    |> parse()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> hash(list)
    |> elem(0)
    |> Enum.take(2)
    |> Enum.reduce(&(&1 * &2))
  end

  def part2(args, size \\ 256) do
    list = for i <- 0..(size - 1), do: i

    args
    |> parse()
    |> String.to_charlist()
    |> Enum.concat([17, 31, 73, 47, 23])
    |> sparse_hash(list)
    |> dense_hash()
    |> IO.inspect()

    # |> hash(list)
    # |> Enum.take(16)
    # |> Enum.map(&Integer.to_string(&1, 16))
    # |> Enum.map(&String.pad_leading(&1, 2, "0"))
    # |> Enum.join("")
  end

  def parse(input) do
    input
    |> String.trim()
  end

  def hash(lengths_sequence, list, initial_pos \\ 0, initial_skip \\ 0) do
    size = length(list)

    Enum.reduce(lengths_sequence, {list, initial_pos, initial_skip}, fn length,
                                                                        {list, pos, skip} ->
      {reverse(list, pos, length, size), rem(pos + length + skip, size), skip + 1}
    end)
  end

  def reverse(list, pos, length, size) do
    # Extract elements with wrapping
    indices = Enum.map(0..(length - 1)//1, fn i -> rem(pos + i, size) end)
    elements = Enum.map(indices, fn idx -> Enum.at(list, idx) end)

    # Reverse the elements
    reversed_elements = Enum.reverse(elements)

    # Put them back with wrapping
    Enum.zip(indices, reversed_elements)
    |> Enum.reduce(list, fn {idx, val}, acc ->
      List.replace_at(acc, idx, val)
    end)
  end

  def sparse_hash(lengths_sequence, initial_list) do
    Enum.reduce(0..63, {initial_list, 0, 0}, fn _, {list, pos, skip} ->
      hash(lengths_sequence, list, pos, skip)
    end)
    |> elem(0)
  end

  def dense_hash(sparse_hash) do
    Enum.chunk_every(sparse_hash, 16)
    |> Enum.map(fn chunk -> Enum.reduce(chunk, &Bitwise.bxor(&1, &2)) end)
    |> Enum.map(&(Integer.to_string(&1, 16) |> String.pad_leading(2, "0")))
    |> Enum.join("")
    |> String.downcase()
  end
end
