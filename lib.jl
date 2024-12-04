# utils to be included in daily solutions:
# include("../lib.jl")

parseints(s:: AbstractString) = parse.(Int, split(s))
parseints(strs:: AbstractVector{<:AbstractString}) = parse.(Int, strs)
parseints(ints:: AbstractVector{<:Integer}) = Int.(ints)

function makegrid(lines:: AbstractVector{<:AbstractString}; bg:: Char = '.', sentinels:: Bool = false)
	n = length(lines)
	m = maximum(length.(lines))
	if sentinels
		grid = fill(bg, (n+2, m+2))
		for i in 1:n
			k = length(lines[i])
			for j in 1:k
				grid[i+1, j+1] = lines[i][j]
			end
		end
		return grid
	else
		grid = fill(bg, (n, m))
		for i in 1:n
			k = length(lines[i])
			for j in 1:k
				grid[i, j] = lines[i][j]
			end
		end
		return grid
	end
end
