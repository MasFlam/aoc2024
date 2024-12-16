using DataStructures

include("../lib.jl")
function aocmain()


lines = readlines("in.txt")
# lines=split("""###############
# #.......#....E#
# #.#.###.#.###.#
# #.....#.#...#.#
# #.###.#####.#.#
# #.#.#.......#.#
# #.#.#####.###.#
# #...........#.#
# ###.#.#####.#.#
# #...#.....#.#.#
# #.#.#.###.#.#.#
# #.....#...#.#.#
# #.###.#.#.#.#.#
# #S..#.....#...#
# ###############""", '\n')

grid = makegrid(lines)
n = length(lines)
m = length(lines[1])

si = 0
sj = 0
ti = 0
tj = 0

for i in 1:n
	for j in 1:m
		if grid[i, j] == 'S'
			si, sj = i, j
		elseif grid[i, j] == 'E'
			ti, tj = i, j
		end
	end
end

println("start:  $si, $sj")
println("target: $ti, $tj")


# 1 >
# 2 v
# 3 <
# 4 ^
dis = fill(div(typemax(Int),2), 4, n, m)


que = DataStructures.PriorityQueue()#Base.Order.Reverse)

push!(que, (si, sj, 1) => 0)
dis[1, si, sj] = 0

while !isempty(que)
	(i, j, dir), dd = dequeue_pair!(que)
	d = dis[dir, i, j]
	#println("i=$i, j=$j, dst=$d, dir=$dir")
	if dir == 1
		if j<m && grid[i, j+1] != '#' && dis[1, i, j+1] > d+1
			dis[1, i, j+1] = d+1
			push!(que, (i, j+1, dir) => d+1)
		end
	elseif dir == 2
		if i<n && grid[i+1, j] != '#' && dis[2, i+1, j] > d+1
			dis[2, i+1, j] = d+1
			push!(que, (i+1, j, dir) => d+1)
		end
	elseif dir == 3
		if j>1 && grid[i, j-1] != '#' && dis[3, i, j-1] > d+1
			dis[3, i, j-1] = d+1
			push!(que, (i, j-1, dir) => d+1)
		end
	elseif dir == 4
		if i>1 && grid[i-1, j] != '#' && dis[4, i-1, j] > d+1
			dis[4, i-1, j] = d+1
			push!(que, (i-1, j, dir) => d+1)
		end
	end
	cw = (dir-1 + 1) % 4 + 1
	ccw = (dir-1 + 4-1) % 4 + 1
	#println("dir=$dir => cw=$cw, ccw=$ccw")
	if dis[cw, i, j] > d+1000
		dis[cw, i, j] = d+1000
		push!(que, (i, j, cw) => d+1000)
	end
	if dis[ccw, i, j] > d+1000
		dis[ccw, i, j] = d+1000
		push!(que, (i, j, ccw) => d+1000)
	end
end

answer = minimum(dis[:, ti, tj])
println(answer)
display(dis[1, :,:] .|> (x -> x >= typemax(Int)/4 ? -1 : x) )
display(dis[2, :,:] .|> (x -> x >= typemax(Int)/4 ? -1 : x) )
display(dis[3, :,:] .|> (x -> x >= typemax(Int)/4 ? -1 : x) )
display(dis[3, :,:] .|> (x -> x >= typemax(Int)/4 ? -1 : x) )


end
aocmain()
