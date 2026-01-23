defmodule Aoc.Day15 do
  # 2^31-1
  @p 2_147_483_647
  # 7^5
  @mult_a 16807
  @mult_b 48271

  def part1(args) do
    {a0, b0} = parse(args)
    Enum.count(1..40_000_000, fn i -> last_16_bits_equal?(a0, b0, i) end)
  end

  def part2(args) do
    {a0, b0} = parse(args)

    Stream.zip(stream_generator_a(a0), stream_generator_b(b0))
    |> Stream.filter(fn {a, b} -> last_16_bits(a) == last_16_bits(b) end)
    |> Enum.count()
  end

  def parse(input) do
    [a0, b0] =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, " ", trim: true))
      |> Enum.map(&Enum.at(&1, 4))
      |> Enum.map(&String.to_integer/1)

    {a0, b0}
  end

  def last_16_bits_equal?(a0, b0, n) do
    a_n = mod_mult(a0, @mult_a, n)
    b_n = mod_mult(b0, @mult_b, n)

    last_16_bits(a_n) == last_16_bits(b_n)
  end

  def mod_mult(initial, multiplier, n) do
    # a_n = (a0 * multiplier^n) mod p
    result = pow_mod(multiplier, n, @p)

    rem(initial * result, @p)
  end

  def last_16_bits(value) do
    # Extract last 16 bits
    # or rem(value, 65536)
    Bitwise.band(value, 0xFFFF)
  end

  def stream_generator_a(a0) do
    Stream.map(1..40_000_000, fn i -> mod_mult(a0, @mult_a, i) end)
    |> Stream.filter(&(rem(&1, 4) == 0))
    |> Stream.take(5_000_000)
  end

  def stream_generator_b(b0) do
    Stream.map(1..40_000_000, fn i -> mod_mult(b0, @mult_b, i) end)
    |> Stream.filter(&(rem(&1, 8) == 0))
    |> Stream.take(5_000_000)
  end

  def pow_mod(base, exp, mod) do
    result_binary = :crypto.mod_pow(base, exp, mod)
    :binary.decode_unsigned(result_binary)
  end
end
