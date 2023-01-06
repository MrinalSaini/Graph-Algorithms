using Graphs
using JLD2

function kruskal(adj_list, weights)
    A = []
    S = []
    for i=1:length(adj_list)
        append!(S, [[i]])
    end
    P = [1:length(adj_list);]
    W = sort([s for s in unique(weights) if !isnothing(s)])
    for w in W
        for e in findall(x -> x==w, weights)
            if P[e[1]]!=P[e[2]]
                append!(A, [[e[1], e[2]]])
                S[P[e[1]]] = union(S[P[e[1]]], S[P[e[2]]])
                for i in S[P[e[2]]]
                    S[P[i]] = nothing
                    P[i]=P[e[1]]
                end
            end
        end
    end
    return A
end

# Adj_list = [[2,4], [1,3,4], [2], [1,2,5,6], [4,6], [4,5]]
# Weights = [[nothing, 5, nothing, 3, nothing, nothing] [5, nothing, 6, 7, nothing, nothing] [nothing, 6, nothing, nothing, nothing, nothing] [3, 7, nothing, nothing, 4, 3] [nothing, nothing, nothing, 4, nothing, 2] [nothing, nothing, nothing, 3, 2, nothing]]

Adj_list = [[2,3,5], [1,3,4], [1,2,4,5], [2,3,5], [1,3,4]]
Weights = [[nothing, 3, 4, nothing, 3] [3, nothing, 2, 6, nothing] [4, 2, nothing, 4, 6] [nothing, 6, 4, nothing, 7] [3, nothing, 6, 7, nothing]]

tree = kruskal(Adj_list, Weights)

println(tree)