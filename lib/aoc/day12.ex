defmodule Aoc.Day12 do
  def part1(args) do
    args
    |> parse()
    |> find_groups()
    |> Enum.find(fn group -> MapSet.member?(group, 0) end)
    |> MapSet.size()
  end

  def part2(args) do
    args
    |> parse()
    |> find_groups()
    |> Enum.count()
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " <-> ", trim: true))
    |> Enum.map(fn [id, neighbors] ->
      {String.to_integer(id), String.split(neighbors, ", ") |> Enum.map(&String.to_integer/1)}
    end)
    |> Map.new()
  end

  def find_groups(graph) do
    sorted_graph = Enum.sort_by(graph, &elem(&1, 0))

    {groups, _} =
      Enum.reduce(sorted_graph, {[], MapSet.new()}, fn {node, neighbors}, {groups, visited} ->
        if MapSet.member?(visited, node) do
          {groups, visited}
        else
          new_group = MapSet.new([node | neighbors])
          merged_groups = merge_all_overlapping(groups, new_group)
          {merged_groups, MapSet.put(visited, node)}
        end
      end)

    groups
  end

  def merge_all_overlapping(groups, new_group) do
    {overlapping, non_overlapping} =
      Enum.split_with(groups, fn group -> !MapSet.disjoint?(group, new_group) end)

    case overlapping do
      [] ->
        [new_group | non_overlapping]

      overlapping_groups ->
        merged = Enum.reduce(overlapping_groups, new_group, &MapSet.union/2)
        [merged | non_overlapping]
    end
  end
end
