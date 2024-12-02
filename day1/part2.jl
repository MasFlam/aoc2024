
lines = readlines("in.txt")

L = Int[]
R = Int[]
counts = Dict{Int, Int}()

for line in lines
	a, b = parse.(Int, split(line))
	push!(L, a)
	push!(R, b)
	counts[b] = get(counts, b, 0) + 1
end

sum(x * get(counts, x, 0) for x in L) |> println
