
include("../lib.jl")

lines = readlines("in.txt")

#=lines = split("""47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
""", "\n")=#

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
	n = length(xs)
	global total
	if !good
#		println(xs)
		for i in 1:n
			for j in i+1:n
				a = xs[i]
				b = xs[j]
				if (b, a) in rules
					xs[j] = a
					xs[i] = b
				end
			end
		end
#		println("-> ", xs)
		total += xs[div(n, 2) + 1]
	end
end

println(total)
