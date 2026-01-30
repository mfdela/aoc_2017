defmodule Aoc.Day24 do
  def part1(args) do
    components = parse(args)

    # Build all possible bridges starting with port 0
    build_bridges(0, components, [])
    |> Enum.map(&calculate_strength/1)
    |> Enum.max()
  end

  def part2(args) do
    components = parse(args)

    # Build all possible bridges starting with port 0
    bridges = build_bridges(0, components, [])

    # Find the maximum length
    max_length =
      bridges
      |> Enum.map(&length/1)
      |> Enum.max()

    # Filter for bridges of max length and find the strongest
    bridges
    |> Enum.filter(fn bridge -> length(bridge) == max_length end)
    |> Enum.map(&calculate_strength/1)
    |> Enum.max()
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "/"))
    |> Enum.map(fn component -> Enum.map(component, &String.to_integer/1) end)
  end

  # Build all possible bridges starting from the given port
  # Returns a list of bridges, where each bridge is a list of components
  def build_bridges(current_port, available_components, current_bridge) do
    # Find all components that can connect to the current port
    matching_components = find_matching_components(current_port, available_components)

    if Enum.empty?(matching_components) do
      # No more components can be added, return the current bridge
      [current_bridge]
    else
      # Try adding each matching component and recursively build from there
      matching_components
      |> Enum.flat_map(fn {component, other_port} ->
        # Remove this component from available components
        remaining = List.delete(available_components, component)
        # Add this component to the bridge and continue building
        new_bridge = [component | current_bridge]
        build_bridges(other_port, remaining, new_bridge)
      end)
      # Also include the current bridge as a valid option (we can stop here)
      |> then(fn bridges -> [current_bridge | bridges] end)
    end
  end

  # Find all components that have a port matching the given value
  # Returns list of {component, other_port} tuples
  def find_matching_components(port, components) do
    components
    |> Enum.flat_map(fn [a, b] = component ->
      cond do
        a == port -> [{component, b}]
        b == port -> [{component, a}]
        true -> []
      end
    end)
  end

  # Calculate the strength of a bridge (sum of all port values)
  def calculate_strength(bridge) do
    bridge
    |> Enum.flat_map(fn component -> component end)
    |> Enum.sum()
  end
end
