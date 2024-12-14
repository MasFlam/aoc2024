include("../lib.jl")
function aocmain()


lines = readlines("in.txt")
#lines = split("""p=0,4 v=3,-3
#p=6,3 v=-1,-3
#p=10,3 v=-1,2
#p=2,0 v=2,-1
#p=0,0 v=1,3
#p=3,0 v=-2,-2
#p=7,6 v=-1,-3
#p=3,0 v=-1,-2
#p=9,3 v=2,3
#p=7,3 v=-1,2
#p=2,4 v=2,-3
#p=9,5 v=-3,-3""", '\n')

W = 101
H = 103

grid = fill([], W, H)
for x in 1:W
	for y in 1:H
		grid[x, y] = []
	end
end

robots = []

for line in lines
	s, t = split(line)
	px, py = parseints(split(replace(s, r"[^0-9,-]" => ""), ','))
	vx, vy = parseints(split(replace(t, r"[^0-9,-]" => ""), ','))
	
	push!(robots, ((px, py), (vx, vy)))
	
	p2x = ((px + 100vx) % W + W) % W
	p2y = ((py + 100vy) % H + H) % H
	
	push!(grid[p2x + 1, p2y + 1], length(robots))
end

counts = zeros(Int, 2, 2)

midX = div(W + 1, 2)
midY = div(H + 1, 2)


#for j in 1:H
#	for i in 1:W
#		print(length(grid[i, j]), ' ')
#	end
#	println()
#end

for i in 1:W
	for j in 1:H
		k = length(grid[i, j])
		(i == midX || j == midY) && continue
		xx = i < midX ? 1 : 2
		yy = j < midY ? 1 : 2
		counts[xx, yy] += k
	end
end

println(prod(counts))



end
aocmain()
