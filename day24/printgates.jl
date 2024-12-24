include("../lib.jl")
lines = readlines("in.txt")

_, gates = vsplit(lines, isempty)

# gate 12 with 179
# gate 48 with 216
# gate 26 with 170
# gate 47 with 209
swaps=[
(47, 209),
(26, 170),
(48, 216),
(12, 179),
]

names = []
for (a,b) in swaps
	x = split(gates[a])[end]
	y = split(gates[b])[end]
	push!(names, x, y)
end
sort!(names)
println(join(names, ','))
