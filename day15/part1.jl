include("../lib.jl")
function aocmain()


lines = readlines("in.txt")

lines_grid, lines_moves = vsplit(lines, isempty)

grid = makegrid(lines_grid)
n = length(lines_grid)
m = length(lines_grid[1])

posi = 0
posj = 0

for i in 1:n
	for j in 1:m
		if grid[i, j] == '@'
			posi = i
			posj = j
		end
	end
end


moves = join(lines_moves, "")

for move in moves
	if move == '>'
		lastO = posj
		for j in posj+1:m
			if grid[posi, j] == 'O'
				lastO = j
			else
				break
			end
		end
		grid[posi, lastO+1] != '.' && continue
		grid[posi, lastO+1] = 'O'
		grid[posi, posj+1] = '@'
		grid[posi, posj] = '.'
		posj += 1
	elseif move == '<'
		lastO = posj
		for j in reverse(1:posj-1)
			if grid[posi, j] == 'O'
				lastO = j
			else
				break
			end
		end
		grid[posi, lastO-1] != '.' && continue
		grid[posi, lastO-1] = 'O'
		grid[posi, posj-1] = '@'
		grid[posi, posj] = '.'
		posj -= 1
	elseif move == '^'
		lastO = posi
		for i in reverse(1:posi-1)
			if grid[i, posj] == 'O'
				lastO = i
			else
				break
			end
		end
		grid[lastO-1, posj] != '.' && continue
		grid[lastO-1, posj] = 'O'
		grid[posi-1, posj] = '@'
		grid[posi, posj] = '.'
		posi -= 1
	elseif move == 'v'
		lastO = posi
		for i in posi+1:n
			if grid[i, posj] == 'O'
				lastO = i
			else
				break
			end
		end
		grid[lastO+1, posj] != '.' && continue
		grid[lastO+1, posj] = 'O'
		grid[posi+1, posj] = '@'
		grid[posi, posj] = '.'
		posi += 1
	end
end

for i in 1:n
	for j in 1:m
		print(grid[i, j])
	end
	println()
end

totalans = 0

for i in 1:n
	for j in 1:m
		if grid[i, j] == 'O'
			totalans += 100*(i-1) + (j-1)
		end
	end
end

println(totalans)



end
aocmain()
