include("../lib.jl")
function aocmain()


lines = readlines("in.txt")

W = 101
H = 103

robots = []

for line in lines
	s, t = split(line)
	px, py = parseints(split(replace(s, r"[^0-9,-]" => ""), ','))
	vx, vy = parseints(split(replace(t, r"[^0-9,-]" => ""), ','))
	push!(robots, ((px, py), (vx, vy)))
end

midX = div(W + 1, 2)
midY = div(H + 1, 2)

function visualize()
	io = IOBuffer()
	for y in 1:H
		for x in 1:W
			print(io, grid[x,y] ? '$' : ' ')
		end
		println(io)
	end
	print(String(take!(io)))
end

n = length(robots)
grid = falses(W, H)

record = 0

function isnice()
	score = 0
	for ((px, py), (vx, vy)) in robots
		ok = false
		for (x, y) in nbors(px, py, diag=true)
			x = (W+x) % W + 1
			y = (H+y) % H + 1
			ok = ok || grid[x,y]
		end
		score += Int(ok)
	end
	res = false
	if score >= record-5
		res = true 
	end
	record = max(record, score)
	res
end

for i in 1:100000000
	for j in 1:n
		((px, py), (vx, vy)) = robots[j]
		px = (px + vx + W) % W
		py = (py + vy + H) % H
		robots[j] = ((px, py), (vx, vy))
	end
	
	grid = falses(W, H)
	for ((px, py), (vx, vy)) in robots
		grid[px+1, py+1] = true
	end
	
	if isnice()
		println("\n\n\nAfter $i iterations:")
		visualize()
	end
end

#println(prod(counts))



end
aocmain()
