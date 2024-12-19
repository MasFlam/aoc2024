include("../lib.jl")
function aocmain()


lines = readlines("in.txt")

foo, bar = vsplit(lines, isempty)

patterns = split(foo[1], ", ")
strings = bar


function cando(target)
	n = length(target)
	dp = zeros(Int, n)
	
	for i in 1:n
		for pat in patterns
			k = length(pat)
			i-k+1 < 1 && continue
			s = view(target, i-k+1:i)
			if s == pat
				dp[i] += i-k == 0 ? 1 : dp[i-k]
			end
		end
	end
	
	return dp[n]
end


total = 0
for string in strings
	ways = cando(string)
	total += ways
end
println(total)


end
aocmain()
