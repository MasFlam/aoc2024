
lines = readlines("in.txt")

L = Int[]
R = Int[]

for line in lines
	a, b = parse.(Int, split(line))
	push!(L, a)
	push!(R, b)
end

sort!(L)
sort!(R)

sum(abs(a-b) for (a,b) in zip(L, R)) |> println
