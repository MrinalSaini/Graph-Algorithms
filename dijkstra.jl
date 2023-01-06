using Graphs
using JLD2

function dijkstra(adj_list, weights, s)
    for i in weights
        if !(isnothing(i)) && i<0
            println("Graph contain negative weights")
            return nothing, nothing
        end
    end
    
    d = repeat([2^10], length(adj_list))
    p = repeat([0], length(adj_list))
    d[s] = 0

    S = [0]
    Q = [1:length(adj_list);]

    while !(isempty(Q))
        j = 1
        u = Q[j]
        for i=1:length(Q)
           if d[Q[i]] < d[u]
                u = Q[i]
                j = i
           end
        end
        
        append!(S, u)
        popat!(Q, j)
        for i in adj_list[u]
            if d[u] + weights[u,i] < d[i]
                d[i] = d[u] + weights[u,i]
                p[i] = u
            end 
        end
    end
    d = replace(d, 2^10=>"Inf")
    return d, p
end

function printpath(traverse, i, path)
    if traverse[i]==0
        append!(path, [i])
        return
    end
    printpath(traverse, traverse[i], path)
    append!(path, [i])
    return path
end

# Adj_list = load_object("sim_adjlist.jld2")
# Weights = load_object("sim_weights.jld2")

Adj_list = [[2,4], [1,3,4], [2], [1,2,5,6], [4,6], [4,5]]
Weights = [[nothing, 5, nothing, 3, nothing, nothing] [5, nothing, 6, 7, nothing, nothing] [nothing, 6, nothing, nothing, nothing, nothing] [3, 7, nothing, nothing, 4, 3] [nothing, nothing, nothing, 4, nothing, 2] [nothing, nothing, nothing, 3, 2, nothing]]

print("Source Vertex : ")
s = readline()
s = parse(Int64, s)

Distance, Traverse = dijkstra(Adj_list, Weights, s)
println(Traverse)

if !(isnothing(Distance))
    for i=1:length(Adj_list)
        path = []
        path = printpath(Traverse, i, path)
        println(i, " -> ", path, " -> ", Distance[i])
    end
end