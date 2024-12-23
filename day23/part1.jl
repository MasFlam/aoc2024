include("../lib.jl")
function aocmain()


lines = readlines("in.txt")

graph = Dict{String, Vector{String}}()

function connect(a, b)
	if a in keys(graph)
		push!(graph[a], b)
	else
		graph[a] = [b]
	end
	nothing
end

for line in lines
	a, b = split(line, '-')
	connect(a,b)
	connect(b,a)
end

totalcount = 0
for a in keys(graph)
	for b in graph[a]
		for c in graph[b]
			if a in graph[c]
				if 't' in (a[1], b[1], c[1])
					totalcount += 1
				end
			end
		end
	end
end
println(totalcount / factorial(3))


end
aocmain()
