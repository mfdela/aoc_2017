defmodule Aoc.Day20 do
  def part1(args) do
    args
    |> parse()
    |> loop(10000)
    |> Enum.min_by(fn {_, {px, py, pz, _, _, _, _, _, _}} -> abs(px) + abs(py) + abs(pz) end)
    |> elem(0)
    |> IO.inspect()
  end

  def part2(args) do
    args
    |> parse()
    |> loop_with_collision_detection(10000)
    |> Enum.count()
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(&parse_particle/1)
    |> Map.new()
  end

  def parse_particle({line, index}) do
    [px, py, pz, vx, vy, vz, ax, ay, az] =
      Regex.run(
        ~r/p=<(-?\d+),(-?\d+),(-?\d+)>, v=<(-?\d+),(-?\d+),(-?\d+)>, a=<(-?\d+),(-?\d+),(-?\d+)>/,
        line,
        capture: :all_but_first
      )
      |> Enum.map(&String.to_integer/1)

    {index, {px, py, pz, vx, vy, vz, ax, ay, az}}
  end

  def tick(particles) do
    particles
    |> Enum.sort_by(fn {id, _} -> id end)
    |> Enum.map(fn {index, {px, py, pz, vx, vy, vz, ax, ay, az}} ->
      {index, {px + vx + ax, py + vy + ay, pz + vz + az, vx + ax, vy + ay, vz + az, ax, ay, az}}
    end)
    |> Map.new()
  end

  def loop(particles, 0), do: particles

  def loop(particles, max_steps) do
    particles
    |> tick()
    |> loop(max_steps - 1)
  end

  def loop_with_collision_detection(particles, 0), do: particles

  def loop_with_collision_detection(particles, max_steps) do
    new_particles =
      particles
      |> tick()

    new_particles
    |> Enum.group_by(fn {_, {px, py, pz, _, _, _, _, _, _}} -> {px, py, pz} end)
    |> Enum.filter(fn {_pos, ps} -> length(ps) > 1 end)
    |> Enum.flat_map(fn {_pos, ps} -> ps end)
    |> Enum.map(fn {index, _} -> index end)
    |> delete_particles(new_particles)
    |> loop_with_collision_detection(max_steps - 1)
  end

  def delete_particles(particles_to_delete, particles) do
    particles_to_delete
    |> Enum.reduce(particles, fn index, acc -> Map.delete(acc, index) end)
  end
end
