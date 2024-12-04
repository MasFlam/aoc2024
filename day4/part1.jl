
include("../lib.jl")

lines = readlines("in.txt")
#=lines = split("""
....XXMAS.
.SAMXMS...
...S..A...
..A.A.MS.X
XMASAMX.MM
X.....XA.A
S.S.S.S.SS
.A.A.A.A.A
..M.M.M.MM
.X.X.XMASX"""=#

grid = makegrid(lines)

n = length(lines)
m = length(lines[1])

count = 0

for i in 1:n-3
	global count
	for j in 1:m-3
		#a = grid[i:i+3, j] # vert
		#b = grid[i, j:j+3] # horiz
		c = [grid[i+k, j+k] for k in 0:3] # diag TL->BR
		d = [grid[i+3-k, j+k] for k in 0:3] # diag BL->TR
#		println(d)
#		exit()
		#a in (["XMAS"...], ["SAMX"...]) && (count += 1)
		#b in (["XMAS"...], ["SAMX"...]) && (count += 1)
		c in (["XMAS"...], ["SAMX"...]) && (count += 1)
		d in (["XMAS"...], ["SAMX"...]) && (count += 1)
	end
end

for i in 1:n
	global count
	for j in 1:m-3
		b = grid[i, j:j+3] # horiz
		b in (["XMAS"...], ["SAMX"...]) && (count += 1)
	end
end

for i in 1:n-3
	global count
	for j in 1:m
		a = grid[i:i+3, j] # vert
		a in (["XMAS"...], ["SAMX"...]) && (count += 1)
	end
end

println(count)
