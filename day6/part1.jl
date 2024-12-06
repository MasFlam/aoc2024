
include("../lib.jl")

lines = readlines("in.txt")

grid = makegrid(lines)

n = length(lines)
m = length(lines[1])

gi = 0
gj = 0

for i in 1:n
	for j in 1:m
		if grid[i, j] == '^'
			global gi
			global gj
			gi = i
			gj = j
		end
	end
end

dir = '^'
i = gi
j = gj

while true
	global i
	global j
	global dir
	grid[i, j] = 'X'
	if dir == '^'
		if i == 1
			break
		elseif grid[i - 1, j] == '#'
			dir = '>'
		else
			i -= 1
		end
	elseif dir == '>'
		if j == m
			break
		elseif grid[i, j+1] == '#'
			dir = 'v'
		else
			j += 1
		end
	elseif dir == 'v'
		if i == n
			break
		elseif grid[i+1, j] == '#'
			dir = '<'
		else
			i += 1
		end
	elseif dir == '<'
		if j == 1
			break
		elseif grid[i, j-1] == '#'
			dir = '^'
		else
			j -= 1
		end
	end
end

println(count(c -> c == 'X', [grid...]))
