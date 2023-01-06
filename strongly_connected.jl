function transpose_graph(adj_list)
    reverse = [[] for i=1:length(adj_list)]
    for v=1:length(adj_list)
        for i in adj_list[v]
            append!(reverse[i], v)
        end
    end
    return reverse
end

function fill_order(s, adj_list, visited, stack)
    visited[s]=1
    for i in adj_list[s]
        if visited[i]==0
            visited, stack = fill_order(i, adj_list, visited, stack)
        end
    end
    append!(stack, s)
    return visited, stack
end

function sc_visit(c, visited, rev_list, s)
    visited[s]=1
    append!(c, s)
    for i in rev_list[s]
        if visited[i]==0
            c = sc_visit(c, visited, rev_list, i)
        end
    end
    return c
end

function strongly_connected(adj_list)
    stack = []
    visited = zeros(length(adj_list), 1)
    for i=1:length(adj_list)
        if visited[i]==0
            visited, stack = fill_order(i, adj_list, visited, stack)
        end
    end
    rev_list = transpose_graph(adj_list)
    visited = zeros(length(adj_list), 1)

    components = []
    while !isempty(stack)
        i = pop!(stack)
        c = []
        if visited[i]==0
            c = sc_visit(c, visited, rev_list, i)
            append!(components, [c])
        end
    end
    return components
end

Adj_list = [[2], [3], [4,5], [1], [6], [7], [5,8], []]
println(strongly_connected(Adj_list))