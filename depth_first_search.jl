using Graphs
using JLD2

function depth_first_search(adj_list, s)
    visited = zeros(length(adj_list), 1)
    tree = []
    g = SimpleDiGraph(length(adj_list))
    visited[s]=1
    append!(tree, s)

    tree, visited, g = dfs_visit(adj_list, visited, tree, g, s)
    return tree, g
end

function dfs_visit(adj_list, visited, tree, g, s)
    for i in adj_list[s]
        if visited[i]==0.0
            visited[i]=1
            append!(tree, i)
            add_edge!(g, s, i)
            tree, visited, g = dfs_visit(adj_list, visited, tree, g, i)
        end
    end
    return tree, visited, g
end

# Adj_list = load_object("dir_adjlist.jld2")

Adj_list = [[4], [3], [2], [1,5], [4], []]
print("Source Vertex : ")
s = readline()
s = parse(Int64, s)
tree, dfs_graph = depth_first_search(Adj_list, s)
println(tree)
graphplot(dfs_graph, names=1:length(Adj_list), curvature_scalar=0.05, nodesize=0.2)

# Graph = loadgraph("digraph.lgz")
# graphplot(dfs_tree(Graph, 2), names=1:length(Adj_list), curvature_scalar=0.05, nodesize=0.2)