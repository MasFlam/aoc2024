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

function printgrid(io:: IO, grid:: AbstractMatrix{<:AbstractChar})
	n, m = size(grid)
	for i in 1:n
		for j in 1:m
			print(io, grid[i,j])
		end
		println(io)
	end
end

printgrid(grid:: AbstractMatrix{<:AbstractChar}) = printgrid(stdout, grid)

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

function manhattan(ax, ay, bx, by; diag:: Bool = false)
	if diag
		dx = abs(ax-bx)
		dy = abs(ay-by)
		md = min(dx, dy)
		dx + dy - md
	else
		abs(ax-bx) + abs(ay-by)
	end
end

manhattan(ax, ay; diag:: Bool = false) = manhattan(ax, ay, 0, 0, diag=diag)
manhattan(a:: Tuple{<:Any, <:Any}, b:: Tuple{<:Any, <:Any}; diag:: Bool = false) = manhattan(a..., b..., diag=diag)

struct Windows
	vector:: Union{AbstractVector, AbstractString}
	winlen:: Integer
end

# Returns an iterable going through all subarrays (or substrings) of length winlen.
windows(vector:: Union{AbstractVector, AbstractString}, winlen:: Integer) = Windows(vector, winlen)

function Base.iterate(w:: Windows)
	if w.winlen <= length(w.vector)
		(view(w.vector, 1:w.winlen), 2)
	else
		nothing
	end
end

function Base.iterate(w:: Windows, idx:: Integer)
	if idx + w.winlen - 1 <= length(w.vector)
		(view(w.vector, idx:idx + w.winlen - 1), idx + 1)
	else
		nothing
	end
end

Base.length(w:: Windows) = max(0, length(w.vector) - w.winlen)

struct Groups
	vector:: Union{AbstractVector, AbstractString}
	grplen:: Integer
end

# Returns an iterable going through subarrays (or substrings) of length grplen, one after another, non-overlapping.
groups(vector:: Union{AbstractVector, AbstractString}, grplen:: Integer) = Groups(vector, grplen)

function Base.iterate(g:: Groups)
	if g.grplen <= length(g.vector)
		(view(g.vector, 1:g.grplen), g.grplen + 1)
	else
		nothing
	end
end

function Base.iterate(g:: Groups, idx:: Integer)
	if idx + g.grplen - 1 <= length(g.vector)
		(view(g.vector, idx:idx + g.grplen - 1), idx + g.grplen)
	else
		nothing
	end
end

Base.length(g:: Groups) = div(length(g.vector), g.grplen)

struct Vsplit
	vector:: AbstractVector
	pred:: Function
end

# Returns an iterable going through subarrays, splitting the vector by elements for which the predicate returns true.
# To filter out empty subarrays, set the keyword argument keepempty to false.
function vsplit(vector:: AbstractVector, pred:: Function; keepempty:: Bool = true)
	vs = Vsplit(vector, pred)
	keepempty ? vs : Iterators.filter(!isempty, vs)
end

function vsplit(vector:: AbstractVector, splitval; keepempty:: Bool = true)
	vsplit(vector, x -> x == splitval, keepempty=keepempty)
end

function Base.iterate(vs:: Vsplit)
	nextidx = findfirst(vs.pred, vs.vector)
	isnothing(nextidx) ? (vs.vector, -1) : (view(vs.vector, 1:nextidx - 1), nextidx + 1)
end

function Base.iterate(vs:: Vsplit, idx:: Integer)
	idx < 0 && return nothing
	nextidx = findnext(vs.pred, vs.vector, idx)
	isnothing(nextidx) ? (view(vs.vector, idx:length(vs.vector)), -1) : (view(vs.vector, idx:nextidx - 1), nextidx + 1)
end
