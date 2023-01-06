using JLD2

function connected_components(adj_list)
    visited = zeros(length(adj_list), 1)
    components = []
    for i=1:length(adj_list)
        c = []
        if visited[i]==0.0
            visited[i]=1
            append!(c,i)
            c, visited =  component(adj_list, visited, c, i)
            append!(components, [sort(c)])
        end
    end
    return components
end

function component(adj_list, visited, tree, s)
    for i in adj_list[s]
        if visited[i]==0.0
            visited[i]=1
            append!(tree, i)
            tree, visited = component(adj_list, visited, tree, i)
        end
    end
    return tree, visited
end

# Adj_list = load_object("sim_adjlist.jld2")

Adj_list = [[4], [3], [2], [1,5], [4], []]
Components = connected_components(Adj_list)

println(Components)
