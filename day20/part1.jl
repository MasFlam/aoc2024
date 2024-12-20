using DataStructures

include("../lib.jl")
function aocmain()


lines = readlines("in.txt")

grid = makegrid(lines)
n = length(lines)
m = length(lines[1])

begdist = zeros(Int, n, m)
enddist = zeros(Int, n, m)

function bfs(dist, si, sj)
	dist[si, sj] = 1
	que = DataStructures.Queue{Tuple{Int,Int}}()
	enqueue!(que, (si, sj))
	while !isempty(que)
		i, j = dequeue!(que)
		d = dist[i, j]
		for (a, b) in nbors(i, j, diag=false)
			(a < 1 || a > n) && continue
			(b < 1 || b > m) && continue
			dist[a, b] != 0 && continue
			grid[a, b] == '#' && continue
			dist[a, b] = d + 1
			enqueue!(que, (a, b))
		end
	end
end

Ai, Aj = 0,0
Bi, Bj = 0,0

for i in 1:n
	for j in 1:m
		if grid[i, j] == 'E'
			Bi, Bj = i, j
		end
		if grid[i, j] == 'S'
			Ai, Aj = i, j
		end
	end
end

bfs(begdist, Ai, Aj)
bfs(enddist, Bi, Bj)

totalcount = 0
thecheats = []

for chi in 1+1:n-1
	for chj in 1+1:m-1
		grid[chi, chj] == '#' && continue
		difs = [
			(-2,  0),
			(-1, +1),
			( 0, +2),
			(+1, +1),
			(+2,  0),
			(+1, -1),
			( 0, -2),
			(-1, -1),
		]
		for (di, dj) in difs
			i2 = chi+di
			j2 = chj+dj
			(i2 < 1 || i2 > n) && continue
			(j2 < 1 || j2 > m) && continue
			grid[i2, j2] == '#' && continue
			x = begdist[chi, chj] - 1
			y = enddist[i2, j2] - 1
			saved = begdist[Bi, Bj] - (x+y+2)
			if saved >= 100
				push!(thecheats, ((chi,chj), (i2,j2)))
				totalcount += 1
			end
		end
	end
end

println(totalcount)


end
aocmain()
