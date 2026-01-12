defmodule Aoc.Day07 do
  def part1(args) do
    args
    |> parse()
    |> elem(1)
    |> find_root()
  end

  def part2(args) do
    {weights, tree} = parse(args)
    root = find_root(tree)

    subtree_map = subtree_weights(tree, weights, root)

    {:unbalanced, _node, expected_weight} =
      find_unbalanced(tree, weights, subtree_map, root)

    expected_weight
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " -> ", trim: true))
    |> Enum.reduce({%{}, %{}}, fn [node | rest], {nodes, parents} ->
      [name, weigth] = Regex.run(~r/(\w+) \((\d+)\)/, node, capture: :all_but_first)

      new_parents =
        case rest do
          [] -> parents
          [children] -> Map.put(parents, name, String.split(children, ", ", trim: true))
        end

      {Map.put(nodes, name, String.to_integer(weigth)), new_parents}
    end)
  end

  def find_root(tree) do
    all_nodes = Map.keys(tree) |> MapSet.new()

    all_children =
      tree
      |> Map.values()
      |> List.flatten()
      |> MapSet.new()

    MapSet.difference(all_nodes, all_children)
    |> MapSet.to_list()
    |> List.first()
  end

  def subtree_weights(tree, weights, root) do
    {_total, subtree_map} = calculate_subtree_weight(tree, weights, root, %{})
    subtree_map
  end

  def calculate_subtree_weight(tree, weights, node, acc) do
    node_weight = Map.get(weights, node, 0)
    children = Map.get(tree, node, [])

    # Recursively calculate children's subtree weights
    {children_total, acc} =
      Enum.reduce(children, {0, acc}, fn child, {total, acc_map} ->
        {child_weight, new_acc} = calculate_subtree_weight(tree, weights, child, acc_map)
        {total + child_weight, new_acc}
      end)

    total_weight = node_weight + children_total
    acc = Map.put(acc, node, total_weight)

    {total_weight, acc}
  end

  def find_unbalanced(tree, weights, subtree_map, node) do
    children = Map.get(tree, node, [])

    if Enum.empty?(children) do
      :balanced
    else
      # Get subtree weights of all children
      child_weights =
        Enum.map(children, fn child ->
          {child, Map.get(subtree_map, child)}
        end)

      # Check if all children have same subtree weight
      weights_only = Enum.map(child_weights, &elem(&1, 1))
      unique_weights = Enum.uniq(weights_only)

      cond do
        # All children balanced at this level - check their subtrees recursively
        length(unique_weights) == 1 ->
          # Check all children for deeper imbalances
          Enum.reduce_while(children, :balanced, fn child, _acc ->
            case find_unbalanced(tree, weights, subtree_map, child) do
              :balanced -> {:cont, :balanced}
              unbalanced -> {:halt, unbalanced}
            end
          end)

        # Found unbalanced children - but we need to check if the problem is deeper
        true ->
          # Find which weight is the odd one out
          weight_counts = Enum.frequencies(weights_only)
          wrong_weight = Enum.find(weight_counts, fn {_w, count} -> count == 1 end) |> elem(0)
          correct_weight = Enum.find(weight_counts, fn {_w, count} -> count > 1 end) |> elem(0)

          # Find the node with wrong weight
          wrong_node =
            Enum.find(child_weights, fn {_n, w} -> w == wrong_weight end)
            |> elem(0)

          # CHECK: Is the wrong_node itself balanced? If not, continue deeper
          case find_unbalanced(tree, weights, subtree_map, wrong_node) do
            # The wrong node has an internal imbalance - that's the real problem
            {:unbalanced, deeper_node, deeper_weight} ->
              {:unbalanced, deeper_node, deeper_weight}

            # The wrong node is internally balanced - IT is the problem
            :balanced ->
              # Calculate what the node's weight should be
              current_node_weight = Map.get(weights, wrong_node)
              diff = correct_weight - wrong_weight
              expected_weight = current_node_weight + diff

              {:unbalanced, wrong_node, expected_weight}
          end
      end
    end
  end
end
