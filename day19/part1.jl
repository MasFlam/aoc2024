include("../lib.jl")
function aocmain()


lines = readlines("in.txt")

foo, bar = vsplit(lines, isempty)

patterns = split(foo[1], ", ")
strings = bar


function cando(target)
	n = length(target)
	n == 0 && return true
	for pat in patterns
		k = length(pat)
		k > n && continue
		s = view(target, 1:k)
		if s == pat
			if cando(view(target, k+1:n))
				return true
			end
		end
	end
	return false
end


total = 0
for string in strings
	if cando(string)
		total += 1
	end
end
println(total)


end
aocmain()
