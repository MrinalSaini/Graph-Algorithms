using Graphs
using JLD2

function bellman_ford(adj_list, weights, s)
    d = repeat([2^10], length(adj_list))
    p = repeat([0], length(adj_list))
    d[s] = 0
    for i in adj_list[s]
        d[i] = weights[s,i]
    end
    for i=1:(length(adj_list)-1)
        for j=1:length(adj_list)
            for k in adj_list[j]
                if k>j
                    if d[j] + weights[j,k] < d[k]
                        d[k] = d[j] + weights[j,k]
                        p[k] = j
                    end
                end 
            end
        end
    end
    for j=1:length(adj_list)
        for k in adj_list[j]
            if d[j] + weights[j,k] < d[k]
                if k>j
                    print("Graph contains negative weight cycle")
                    return nothing
                end
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


# Adj_list = load_object("dir_adjlist.jld2")
# Weights = load_object("dir_weights.jld2")

Adj_list = [[2,4], [1,3,4], [2], [1,2,5,6], [4,6], [4,5]]
Weights = [[nothing, 5, nothing, 3, nothing, nothing] [5, nothing, 6, 7, nothing, nothing] [nothing, 6, nothing, nothing, nothing, nothing] [3, 7, nothing, nothing, 4, 3] [nothing, nothing, nothing, 4, nothing, 2] [nothing, nothing, nothing, 3, 2, nothing]]

# Adj_list = [[2,4], [1,3,4], [2], [1,2,5,6], [4,6], [4,5]]
# Weights = [[nothing, 5, nothing, 3, nothing, nothing] [5, nothing, 6, -7, nothing, nothing] [nothing, 6, nothing, nothing, nothing, nothing] [3, -7, nothing, nothing, 4, 3] [nothing, nothing, nothing, 4, nothing, 2] [nothing, nothing, nothing, 3, 2, nothing]]


print("Source Vertex : ")
s = readline()
s = parse(Int64, s)

Distance, Traverse = bellman_ford(Adj_list, Weights, s)
println(Traverse)

if !(isnothing(Distance))
    for i=1:length(Adj_list)
        path = []
        path = printpath(Traverse, i, path)
        println(i, " -> ", path, " -> ", Distance[i])
    end
end