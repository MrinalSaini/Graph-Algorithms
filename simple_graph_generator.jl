using Random
using StatsBase
using Graphs
using GraphRecipes
using Plots
using JLD2

Random.seed!(0)

function generate_simple_graph(n,m,l,u)
    if m<=(n*(n-1)/2)
        W = Array{Union{Nothing, Int}}(nothing, n, n)
        g = SimpleGraph(n)
        A = [Int[] for i=1:n]
        j = 1
        while j<=m
            s = sample(1:n, 2, replace=false)
            if !(issubset(s[2], A[s[1]]))
                append!(A[s[1]], s[2])
                append!(A[s[2]], s[1])
                add_edge!(g, s[1], s[2])
                W[s[1], s[2]] = sample(l:u, 1, replace=true)[1]
                W[s[2], s[1]] = W[s[1], s[2]]
                j = j+1
            end
        end
        for i=1:length(A)
            A[i]=sort(A[i])
        end
        return A, W, g
    else
        println("Can't Generate Graph; Number of edges exceeds V(V-1)/2")
        return nothing, nothing, nothing
    end
end

print("Number of Vertices : ")
n = readline()
n = parse(Int64, n)
print("Number of Edges : ")
m = readline()
m = parse(Int64, m)
print("Lower limit for weights : ")
l = readline()
l = parse(Int64, l)
print("Upper limit for weights : ")
u = readline()
u = parse(Int64, u)
Adj_list, Weights, Graph  = generate_simple_graph(n, m, l, u)

if !(isnothing(Adj_list))
    save_object("sim_adjlist.jld2", Adj_list)
    save_object("sim_weights.jld2", Weights)
    savegraph("simgraph.lgz", Graph)
    println("Adjacency List :")
    for i in 1:n
        println(i, ":", Adj_list[i])
    end
    println()
    println(Weights)
    graphplot(Graph, names=1:n, curvature_scalar=0.05, nodesize=0.2)
end