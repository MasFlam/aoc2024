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
prede = fill([], 4, n, m)

for i in 1:n
	for j in 1:m
		prede[1,i,j] = []
		prede[2,i,j] = []
		prede[3,i,j] = []
		prede[4,i,j] = []
	end
end

que = DataStructures.PriorityQueue()#Base.Order.Reverse)

push!(que, (si, sj, 1) => 0)
dis[1, si, sj] = 0

while !isempty(que)
	(i, j, dir), dd = dequeue_pair!(que)
	d = dis[dir, i, j]
	#println("i=$i, j=$j, dst=$d, dir=$dir")
	if dir == 1
		if j<m && grid[i, j+1] != '#'
			if dis[dir, i, j+1] > d+1
				prede[dir, i, j+1] = [(i,j,dir)]
				dis[dir, i, j+1] = d+1
				push!(que, (i, j+1, dir) => d+1)
			elseif dis[dir, i, j+1] == d+1
				push!(prede[dir, i, j+1], (i,j,dir))
			end
		end
	elseif dir == 2
		if i<n && grid[i+1, j] != '#'
			if dis[dir, i+1, j] > d+1
				prede[dir, i+1, j] = [(i,j,dir)]
				dis[dir, i+1, j] = d+1
				push!(que, (i+1, j, dir) => d+1)
			elseif dis[dir, i+1, j] ==d+1
				push!(prede[dir, i+1, j], (i,j,dir))
			end
		end
	elseif dir == 3
		if j>1 && grid[i, j-1] != '#'
			if dis[dir, i, j-1] > d+1
				prede[dir, i, j-1] = [(i,j,dir)]
				dis[dir, i, j-1] = d+1
				push!(que, (i, j-1, dir) => d+1)
			elseif dis[dir, i, j-1] ==d+1
				push!(prede[dir, i, j-1], (i,j,dir))
			end
		end
	elseif dir == 4
		if i>1 && grid[i-1, j] != '#'
			if dis[dir, i-1, j] > d+1
				prede[dir, i-1, j] = [(i,j,dir)]
				dis[dir, i-1, j] = d+1
				push!(que, (i-1, j, dir) => d+1)
			elseif dis[dir, i-1, j] ==d+1
				push!(prede[dir, i-1, j], (i,j,dir))
			end
		end
	end
	cw = (dir-1 + 1) % 4 + 1
	ccw = (dir-1 + 4-1) % 4 + 1
	#println("dir=$dir => cw=$cw, ccw=$ccw")
	if dis[cw, i, j] > d+1000
		prede[cw, i, j] = [(i,j,dir)]
		dis[cw, i, j] = d+1000
		push!(que, (i, j, cw) => d+1000)
	elseif dis[cw, i, j] == d+1000
		push!(prede[cw, i, j], (i,j,dir))
	end
	if dis[ccw, i, j] > d+1000
		prede[ccw, i, j] = [(i,j,dir)]
		dis[ccw, i, j] = d+1000
		push!(que, (i, j, ccw) => d+1000)
	elseif dis[ccw, i, j] == d+1000
		push!(prede[ccw, i, j], (i,j,dir))
	end
end

function markpath(i,j,dir)
	println("prede[dir=$dir,i=$i,j=$j] = $(prede[dir,i,j])")
	dis[dir,i,j] == -1 && return
	dis[dir,i,j] = -1
	grid[i,j] = 'O'
	for (i2,j2,dir2) in prede[dir, i,j]
		markpath(i2,j2,dir2)
	end
end

for dir0 in 1:4
	grid[ti,tj] = 'O'
	for (i,j,dir) in prede[dir0, ti, tj]
		println()
		markpath(i,j,dir)
	end
end


for i in 1:n
	for j in 1:m
		print(grid[i,j])
	end
	println()
end


println(count(x -> x=='O', grid))
#display(dis[1, :,:] .|> (x -> x >= typemax(Int)/4 ? -1 : x) )
#display(dis[2, :,:] .|> (x -> x >= typemax(Int)/4 ? -1 : x) )
#display(dis[3, :,:] .|> (x -> x >= typemax(Int)/4 ? -1 : x) )
#display(dis[3, :,:] .|> (x -> x >= typemax(Int)/4 ? -1 : x) )


end
aocmain()
