include("../lib.jl")
function aocmain()


lines = readlines("in.txt")
# lines = split("""##########
# #..O..O.O#
# #......O.#
# #.OO..O.O#
# #..O@..O.#
# #O#..O...#
# #O..O..O.#
# #.OO.O.OO#
# #....O...#
# ##########
# 
# <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
# vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
# ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
# <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
# ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
# ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
# >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
# <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
# ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
# v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^""", '\n')

lines_grid, lines_moves = vsplit(lines, isempty)

lines_grid = lines_grid .|> (line -> replace(line, "#" => "##", "O" => "[]", "." => "..", "@" => "@."))

grid = makegrid(lines_grid)
n = length(lines_grid)
m = length(lines_grid[1])

for i in 1:n
	for j in 1:m
		print(grid[i, j])
	end
	println()
end

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

function checkmove(i, j, di, dj)
	if grid[i, j] == '['
		if dj == 0
			checkmove(i+di, j+dj, di, dj) && checkmove(i+di, j+dj+1, di, dj)
		else
			checkmove(i+di, j+2, di, dj)
		end
	elseif grid[i, j] == ']'
		if dj == 0
			checkmove(i+di, j+dj, di, dj) && checkmove(i+di, j+dj-1, di, dj)
		else
			checkmove(i+di, j-2, di, dj)
		end
	else
		grid[i, j] == '.'
	end
end

function makemove(i, j, di, dj)
	if grid[i, j] == '['
		if dj == 0
			makemove(i+di, j, di, dj)
			makemove(i+di, j+1, di, dj)
			grid[i+di, j  ] = '['
			grid[i+di, j+1] = ']'
			grid[i, j  ] = '.'
			grid[i, j+1] = '.'
		else
			makemove(i, j+2, di, dj)
			grid[i, j+2] = ']'
			grid[i, j+1] = '['
			grid[i, j] = '.'
		end
	elseif grid[i, j] == ']'
		if dj == 0
			makemove(i+di, j, di, dj)
			makemove(i+di, j-1, di, dj)
			grid[i+di, j  ] = ']'
			grid[i+di, j-1] = '['
			grid[i, j  ] = '.'
			grid[i, j-1] = '.'
		else
			makemove(i, j-2, di, dj)
			grid[i, j-2] = '['
			grid[i, j-1] = ']'
			grid[i, j] = '.'
		end
	else
		return
	end
end

for move in moves
	#println("Moving $move")
	
	if move == '>'
		if checkmove(posi, posj+1, 0, 1)
			makemove(posi, posj+1, 0, 1)
			grid[posi, posj+1] = '@'
			grid[posi, posj] = '.'
			posj += 1
		end
	elseif move == '<'
		if checkmove(posi, posj-1, 0, -1)
			makemove(posi, posj-1, 0, -1)
			grid[posi, posj-1] = '@'
			grid[posi, posj] = '.'
			posj -= 1
		end
	elseif move == '^'
		if checkmove(posi-1, posj, -1, 0)
			makemove(posi-1, posj, -1, 0)
			grid[posi-1, posj] = '@'
			grid[posi, posj] = '.'
			posi -= 1
		end
	elseif move == 'v'
		if checkmove(posi+1, posj, 1, 0)
			makemove(posi+1, posj, 1, 0)
			grid[posi+1, posj] = '@'
			grid[posi, posj] = '.'
			posi += 1
		end
	end
	
		
	#for i in 1:n
	#	for j in 1:m
	#		print(grid[i, j])
	#	end
	#	println()
	#end
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
		if grid[i, j] == '['
			totalans += 100*(i-1) + (j-1)
		end
	end
end

println(totalans)



end
aocmain()
