
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

function simulate(grid)
	dir = '^'
	i = gi
	j = gj
	
	maxiter = n * m
	exited = false
	
	for it in 1:maxiter
		grid[i, j] = 'X'
		if dir == '^'
			if i == 1
				exited = true
				break
			elseif grid[i - 1, j] == '#'
				dir = '>'
			else
				i -= 1
			end
		elseif dir == '>'
			if j == m
				exited = true
				break
			elseif grid[i, j+1] == '#'
				dir = 'v'
			else
				j += 1
			end
		elseif dir == 'v'
			if i == n
				exited = true
				break
			elseif grid[i+1, j] == '#'
				dir = '<'
			else
				i += 1
			end
		elseif dir == '<'
			if j == 1
				exited = true
				break
			elseif grid[i, j-1] == '#'
				dir = '^'
			else
				j -= 1
			end
		end
	end
	
	return exited
end

counter = 0

for i in 1:n
	for j in 1:m
		i == gi && j == gj && continue
		grid[i, j] == '#' && continue
		grid2 = copy(grid)
		grid2[i, j] = '#'
		exited = simulate(grid2)
		if !exited
			global counter
			counter += 1
		end
	end
end

println(counter)
