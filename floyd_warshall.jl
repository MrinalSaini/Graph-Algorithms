using Graphs
using JLD2

function printpath(traverse, i, path)
    if traverse[i]==0
        append!(path, [i])
        return
    end
    printpath(traverse, traverse[i], path)
    append!(path, [i])
    return path
end


function floyd_warshall(adj_list, weights)
    d = weights
    d = replace(d, nothing=>2^10)
    p = zeros(Int64, length(adj_list), length(adj_list))

    for i=1:length(adj_list)
        d[i,i]=0
    end
    
    for i=1:length(adj_list)
        for j=1:length(adj_list)
            if !isnothing(p[i,j]) && i!=j
                p[i,j]=i
            end
        end
    end
    p = replace(p, 0=>nothing)

    for k=1:length(adj_list)
        for j=1:length(adj_list)
            for i=1:length(adj_list)
                if d[i,j] > d[i,k] + d[k,j]
                    d[i,j] = d[i,k] + d[k,j]
                    p[i,j] = p[k,j]
                end
            end
        end
    end
    d = replace(d, 2^10=>'∞')
    return d, p
end

# Adj_list = load_object("dir_adjlist.jld2")
# Weights = load_object("dir_weights.jld2")

Adj_list = [[2,4], [1,3,4], [2], [1,2,5,6], [4,6], [4,5]]
Weights = [[nothing, 5, nothing, 3, nothing, nothing] [5, nothing, 6, 7, nothing, nothing] [nothing, 6, nothing, nothing, nothing, nothing] [3, 7, nothing, nothing, 4, 3] [nothing, nothing, nothing, 4, nothing, 2] [nothing, nothing, nothing, 3, 2, nothing]]

Distance, Parents = floyd_warshall(Adj_list, Weights)

Parents = replace(Parents, nothing=>0)

if !isnothing(Distance)
    for i=1:length(Adj_list)
    println("Source = ", i)
    Dist = Distance[i,:]
    Traverse = Parents[i,:]
        for j=1:length(Adj_list)
            path = []
            path = printpath(Traverse, j, path)
            println(j, " -> ", path, " -> ", Dist[j])
        end 
    println()
    end  
end

