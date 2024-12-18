using DataStructures

include("../lib.jl")
function aocmain()


lines = readlines("in.txt")

input = [parseints(reverse(split(line, ','))) .+ 1 for line in lines]

n = 71
m = 71

#for i in 1:n
#	for j in 1:m
#		print(banned[i,j] ? '#' : '.')
#	end
#	println()
#end

function bfs(banned, pi, pj)
	dists = zeros(Int, n, m)
	dists[pi, pj] = 1
	que = Tuple{Int, Int}[] #DataStructures.Queue{Tuple{Int, Int}}()
	push!(que, (pi, pj))
	while !isempty(que)
		i, j = popfirst!(que)
		for (bi, bj) in nbors(i, j, diag=false)
			(bi < 1 || bi > n) && continue
			(bj < 1 || bj > m) && continue
			banned[bi, bj] && continue
			dists[bi, bj] != 0 && continue
			dists[bi, bj] = dists[i, j] + 1
			push!(que, (bi, bj))
		end
	end
	dists[n, m] - 1
end

function check(K)
	banned = falses(n, m)
	for k in 1:K
		i, j = input[k]
		banned[i, j] = true
	end
	bfs(banned, 1, 1) != -1
end


b = 1
e = length(input)

while b < e
	mid = div(b+e, 2)
	if check(mid)
		b = mid + 1
	else
		e = mid
	end
end

println(b)

for K in b-10:b+10
	if !check(K)
		println("Actually, $K")
		println(input[K])
		return
	end
end


end
aocmain()
