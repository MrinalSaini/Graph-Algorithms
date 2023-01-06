function printpath(traverse, i, path)
    if traverse[i]==0
        append!(path, [i])
        return
    end
    printpath(traverse, traverse[i], path)
    append!(path, [i])
    return path
end

function bellman_ford(adj_list, weights, s)
    d = repeat([2^10], length(adj_list))
    d[s] = 0
    for i in adj_list[s]    
        d[i] = weights[s,i]
    end
    for i=1:(length(adj_list)-1)
        for j=1:length(adj_list)
            for k in adj_list[j]
                if d[j] + weights[j,k] < d[k]
                    d[k] = d[j] + weights[j,k]
                end
            end
        end
    end
    for j=1:length(adj_list)
        for k in adj_list[j]
            if d[j] + weights[j,k] < d[k]
                print("Graph contains negative weight cycle")
                return nothing
            end 
        end
    end
    return d
end

function dijkstra(adj_list, weights, s)
    for i in weights
        if !(isnothing(i)) && i<0
            print("Negative weight encountered in dijkstra")
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
    return d, p
end


function johnsons(adj_list, weights)
    new_weights = hcat(weights, [nothing for i=1:length(adj_list)])
    new_weights = [new_weights;zeros(Int64, 1, length(adj_list)+1)]
    new_weights[length(adj_list)+1, length(adj_list)+1] = nothing
    append!(adj_list, [[1:length(adj_list);]])

    h = bellman_ford(adj_list, new_weights, length(adj_list))
    if isnothing(h)
        print("Graph contains negative weight cycle")
        return nothing, nothing
    end
    
    for i=1:length(adj_list)
        for j in adj_list[i]
            new_weights[i,j] = new_weights[i,j] + h[i] - h[j]
        end
    end

    weights = new_weights[1:length(adj_list)-1, 1:length(adj_list)-1]
    new_weights = new_weights[1:length(adj_list)-1, 1:length(adj_list)-1]
    parent_matrix = new_weights[1:length(adj_list)-1, 1:length(adj_list)-1]
    adj_list = adj_list[1:length(adj_list)-1]

    for i=1:length(adj_list)
        d, p = dijkstra(adj_list, weights, i)
        if isnothing(d)
            return nothing, nothing
        end
        for j=1:length(adj_list)
            new_weights[i,j] = d[j] + h[j] - h[i]
            parent_matrix[i,j] = p[j]
        end
    end
    return new_weights, parent_matrix
end

# Adj_list = [[2,3], [1,3], [1]]
# Weights = [[nothing, 12, 6] [8, nothing, nothing] [22, -10, nothing]]

Adj_list = [[2,3,5], [4,5], [2], [1,3], [4]]
Weights = [[nothing, nothing, nothing, 2, nothing] [3, nothing, 4, nothing, nothing] [8, nothing, nothing, -5, nothing] [nothing, 1, nothing, nothing, 6] [-4, 7, nothing, nothing, nothing]]

Distance_Matrix, Parents = johnsons(Adj_list, Weights)

if !isnothing(Distance_Matrix)
    for i=1:length(Adj_list)-1 
    println("Source = ", i)
    Dist = Distance_Matrix[i,:]
    Traverse = Parents[i,:]
        for j=1:length(Adj_list)-1
            path = []
            path = printpath(Traverse, j, path)
            println(j, " -> ", path, " -> ", Dist[j])
        end 
    println()
    end  
end



