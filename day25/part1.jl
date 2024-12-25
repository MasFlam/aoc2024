include("../lib.jl")
function aocmain()


lines = readlines("in.txt")

things = vsplit(lines, isempty)

keys = []
locks = []

for thing in things
	h = []
	for i in 1:5
		x = 0
		for j in 2:6
			thing[j][i] == '#' && (x += 1)
		end
		push!(h, x)
	end
	if thing[1][1] == '#'
		push!(locks, h)
	else
		push!(keys, h)
	end
end

function checkfit(key, lock)
	for i in 1:5
		x = key[i] + lock[i]
		x > 5 && return false
	end
	true
end


total = 0
for key in keys
	for lock in locks
		if checkfit(key, lock)
			total += 1
		end
	end
end
println(total)



end
aocmain()
