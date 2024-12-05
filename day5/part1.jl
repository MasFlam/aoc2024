
include("../lib.jl")

lines = readlines("in.txt")

ii = findfirst(line-> line == "", lines)

sect1 = lines[begin:ii-1]
sect2 = lines[ii+1:end]

rules = []

for line in sect1
	a, b = parseints(split(line, '|'))
	push!(rules, (a, b))
end

total = 0

for line in sect2
	xs = parseints(split(line, ','))
	positions = Dict()
	for (i, x) in zip(1:length(xs), xs)
		positions[x] = i
	end
	good = true
	for (a,b) in rules
		if a in keys(positions) && b in keys(positions)
			if positions[a] > positions[b]
				good = false
				break
			else
				# good
			end
		end
	end
	global total
	if good
		total += xs[div(length(xs), 2) + 1]
	end
end

println(total)
