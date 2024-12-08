include("../lib.jl")
function aocmain()


lines = readlines("in.txt")
#=lines = split("""##....#....#
.#.#....0...
..#.#0....#.
..##...0....
....0....#..
.#...#A....#
...#..#.....
#....#.#....
..#.....A...
....#....A..
.#........#.
...#......##""", '\n')=#

grid = makegrid(lines)
n = length(lines)
m = length(lines[1])

locs = Dict()

for i in 1:n
	for j in 1:m
		ch = grid[i, j]
		if ch in 'a':'z' || ch in 'A':'Z' || ch in '0':'9'
			if ch in keys(locs)
				push!(locs[ch], (i, j))
			else
				locs[ch] = [(i, j)]
			end
		end
	end
end

antinodes = Set()

for (ch, coords) in locs
	length(coords) <= 1 && continue
	sort!(coords)
#	println(coords)
	
	for i1 in 1:length(coords)
		for i2 in i1+1:length(coords)
			(ai, aj), (bi, bj) = coords[i1], coords[i2]
			push!(antinodes, (ai, aj))
			push!(antinodes, (bi, bj))
			di = abs(ai - bi)
			dj = abs(aj - bj)
			for k in -(n+m):n+m
				pi = ai - di*k
				qi = bi + di*k
				pj = aj < bj ? aj - dj*k : aj + dj*k
				qj = aj < bj ? bj + dj*k : bj - dj*k
	#			println("=> p=($pi,$pj)  q=($qi,$qj)")
				pi in 1:n && pj in 1:m && push!(antinodes, (pi, pj))
				qi in 1:n && qj in 1:m && push!(antinodes, (qi, qj))
			end
		end
	end
end

#println(antinodes)
println(length(antinodes))


end
aocmain()
