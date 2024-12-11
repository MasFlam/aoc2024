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

function nbors(i, j; diag:: Bool)
	if diag
		(
			(i-1, j-1),
			(i-1, j  ),
			(i-1, j+1),
			(i,   j+1),
			(i+1, j+1),
			(i+1, j  ),
			(i+1, j-1),
			(i,   j-1),
		)
	else
		(
			(i-1, j),
			(i, j+1),
			(i+1, j),
			(i, j-1),
		)
	end
end

struct Windows
	vector:: Union{AbstractVector, AbstractString}
	winlen:: Integer
end

# Returns an iterator going through all subarrays (or substrings) of length winlen.
windows(vector:: Union{AbstractVector, AbstractString}, winlen:: Integer) = Windows(vector, winlen)

function Base.iterate(w:: Windows)
	if w.winlen <= length(w.vector)
		(view(w.vector, 1:w.winlen), 2)
	else
		nothing
	end
end

function Base.iterate(w:: Windows, idx:: Int)
	if idx + w.winlen - 1 <= length(w.vector)
		(view(w.vector, idx:idx + w.winlen - 1), idx + 1)
	else
		nothing
	end
end

Base.length(w:: Windows) = max(0, length(w.vector) - w.winlen)
