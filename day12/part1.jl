include("../lib.jl")
function aocmain()


lines = readlines("in.txt")
grid = makegrid(lines, sentinels=true)
n = length(lines)
m = length(lines[1])

vis = falses(n+2, m+2)

function dfs(i, j, ch)
	sides = 0
	area = 1
	vis[i, j] = true
	for (a, b) in nbors(i, j, diag=false)
		if grid[a, b] != ch
			sides += 1
		elseif !vis[a, b]
			x, y = dfs(a, b, ch)
			sides += x
			area += y
		end
	end
	sides, area
end

total = 0

for i in 1:n
	for j in 1:m
		if !vis[i+1, j+1]
			sides, area = dfs(i+1, j+1, grid[i+1, j+1])
			total += sides * area
		end
	end
end

println(total)


end
aocmain()
