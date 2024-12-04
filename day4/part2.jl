
include("../lib.jl")

lines = readlines("in.txt")

grid = makegrid(lines)

n = length(lines)
m = length(lines[1])

count = 0

for i in 2:n-1
	global count
	for j in 2:m-1
		a = [grid[i+k, j+k] for k in -1:1] # diag TL->BR
		b = [grid[i-k, j+k] for k in -1:1] # diag BL->TR
		
#		exit()
		a in (["MAS"...], ["SAM"...]) && b in (["MAS"...], ["SAM"...]) && (count += 1)
	end
end

println(count)
