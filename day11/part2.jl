include("../lib.jl")
function aocmain()


lines = readlines("in.txt")
input = parseints(lines[1])

memo = Dict{Tuple{Int, Int}, Int}()

function foo(x, n)
	if n == 0
		return 1
	end
	if (x, n) in keys(memo)
		return memo[(x, n)]
	elseif x == 0
		r = foo(1, n-1)
		memo[(x, n)] = r
		return r
	elseif ndigits(x) % 2 == 0
		k = div(ndigits(x), 2)
		a = div(x, 10^k)
		b = x % 10^k
		r = foo(a, n-1) + foo(b, n-1)
		memo[(x, n)] = r
		return r
	else
		r = foo(2024x, n-1)
		memo[(x, n)] = r
		return r
	end
end

total = sum(foo.(input, 75))
println(total)


end
aocmain()
