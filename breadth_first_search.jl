using Graphs
using JLD2

function breadth_first_search(adj_list, s)
    visited = zeros(length(adj_list), 1)
    g = SimpleDiGraph(length(adj_list))
    tree = []
    queue = []
    append!(tree, s)
    append!(queue, s)
    visited[s] = 1
    while !(isempty(queue))
        s = popfirst!(queue)
        for i in adj_list[s]
            if visited[i]==0.0
                add_edge!(g, s, i)
                append!(tree, i)
                append!(queue, i)
                visited[i] = 1
            end
        end
    end
    return tree, g
end

Adj_list = [[2,4], [1,3,4], [2], [1,2,5,6], [4,6], [4,5]]

# Adj_list = load_object("dir_adjlist.jld2")
print("Source Vertex : ")
s = readline()
s = parse(Int64, s)
tree, bfs_graph = breadth_first_search(Adj_list, s)
println(tree)
graphplot(bfs_graph, names=1:length(Adj_list), curvature_scalar=0.05, nodesize=0.2)

# Graph = loadgraph("digraph.lgz")
# graphplot(bfs_tree(Graph, s), names=1:length(Adj_list), curvature_scalar=0.05, nodesize=0.2)

