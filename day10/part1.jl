include("../lib.jl")
function aocmain()


lines = readlines("in.txt")

grid = makegrid(lines, bg='.', sentinels=true)
n = length(lines)
m = length(lines[1])

vis = zeros(Int, n+2, m+2)
tru = 1

function dfs(i, j, ch)
	vis[i, j] = tru
	ch == '9' && return 1
	res = 0
	for (a, b) in ((i+1, j), (i-1, j), (i, j+1), (i, j-1))
		a == 1 && continue
		b == 1 && continue
		a == n+2 && continue
		b == m+2 && continue
		if grid[a, b] == ch + 1 && vis[a, b] != tru
			res += dfs(a, b, ch + 1)
		end
	end
	return res
end

total = 0
for i in 1:n
	for j in 1:m
		if grid[i+1, j+1] == '0'
			score = dfs(i+1, j+1, '0')
			total += score
			tru += 1
		end
	end
end

println(total)


end
aocmain()
