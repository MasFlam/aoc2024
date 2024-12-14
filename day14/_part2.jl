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

# grid = fill([], W, H)
# for x in 1:W
# 	for y in 1:H
# 		grid[x, y] = []
# 	end
# end

robots = []

for line in lines
	s, t = split(line)
	px, py = parseints(split(replace(s, r"[^0-9,-]" => ""), ','))
	vx, vy = parseints(split(replace(t, r"[^0-9,-]" => ""), ','))
	
	push!(robots, ((px, py), (vx, vy)))
	
	#push!(grid[px + 1, py + 1], length(robots))
end

midX = div(W + 1, 2)
midY = div(H + 1, 2)

function isthing()
	vg = falses(W, H)
	for ((px, py), (vx, vy)) in robots
		vg[px+1, py+1] = true
	end
	for y in 1:H-2
#		for x in 1:midX - y
#			vg[x, y] && return false
#		end
		!vg[midX - y + 1, y] && return false
		!vg[midX + y - 1, y] && return false
#		for x in midX - y + 2:midX + y - 2
#			vg[x, y] && return false
#		end
#		for x in midX + y:W
#			vg[x, y] && return false
#		end
	end
	for x in 1:W
		!vg[x, H-1] && return false
	end
#	for x in 1:midX-1
#		vg[x, H] && return false
#	end
	!vg[midX, H] && return false
#	for x in midX+1:W
#		vg[x, H] && return false
#	end
	true
end

n = length(robots)

if isthing()
	println(0)
	return
end

for i in 1:100000000
	for j in 1:n
		((px, py), (vx, vy)) = robots[j]
		px = (px + vx + W) % W
		py = (py + vy + H) % H
		robots[j] = ((px, py), (vx, vy))
	end
	if isthing()
		println(i)
		return
	end
end

#println(prod(counts))



end
aocmain()
