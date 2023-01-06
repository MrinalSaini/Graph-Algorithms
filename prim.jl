using Graphs
using JLD2

function prims(adj_list, weights, s)
    key = repeat([2^10], length(adj_list))
    p = repeat([2^11], length(adj_list))
    key[s] = 0
    Q = [1:length(adj_list);]

    while !(isempty(Q))
        j = 1
        u = Q[j]
        for i=1:length(Q)
           if key[Q[i]] < key[u]
                u = Q[i]
                j = i
           end
        end

        popat!(Q, j)

        for i in adj_list[u]
            if (i ∈ Q) && (weights[u,i] < key[i]) 
                p[i]=u
                key[i] = weights[u,i]
            end 
        end
    end
    
    p = replace(p, 2^11=>nothing)
    # return [s for s in p if !isnothing(s)]
    return p
    end

# Adj_list = [[2,4], [1,3,4], [2], [1,2,5,6], [4,6], [4,5]]
# Weights = [[nothing, 5, nothing, 3, nothing, nothing] [5, nothing, 6, 7, nothing, nothing] [nothing, 6, nothing, nothing, nothing, nothing] [3, 7, nothing, nothing, 4, 3] [nothing, nothing, nothing, 4, nothing, 2] [nothing, nothing, nothing, 3, 2, nothing]]

Adj_list = [[2,3,5], [1,3,4], [1,2,4,5], [2,3,5], [1,3,4]]
Weights = [[nothing, 3, 2, nothing, 3] [3, nothing, 2, 6, nothing] [2, 2, nothing, 4, 6] [nothing, 6, 4, nothing, 4] [3, nothing, 6, 4, nothing]]

tree = prims(Adj_list, Weights, 1)

# total = 0
for i=1:length(tree)
    if !isnothing(tree[i])
        println([i,tree[i]], "  Weight = ", Weights[i,tree[i]])
        # total = total + Weights[i,tree[i]]
    end
end
# println("Total weight of tree = ", total)