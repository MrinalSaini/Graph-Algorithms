function topological_sort(adj_list)
    visited = zeros(length(adj_list), 1)
    stack = []
    for s=1:length(adj_list)
        if visited[s]==0
            visited, stack = top_visit(adj_list, visited, s, stack)
        end
    end
    return reverse(stack)
end

function top_visit(adj_list, visited, s, stack)
    visited[s] = 1
    for i in adj_list[s]
        if visited[i]==0.0
            visited, stack = top_visit(adj_list, visited, i, stack)
        end
    end
    append!(stack, s)
    return visited, stack
end

# Adj_list = [[], [], [4], [2], [1,2], [1,3]]
Adj_list = [[2,4], [3], [], [2,5,6], [6], []]

println(topological_sort(Adj_list))