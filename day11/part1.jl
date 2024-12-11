include("../lib.jl")
function aocmain()


lines = readlines("in.txt")
input = parseints(lines[1])

function blink(xs)
	res = Int[]
	for x in xs
		if x == 0
			push!(res, 1)
		elseif ndigits(x) % 2 == 0
			k = div(ndigits(x), 2)
			a = div(x, 10^k)
			b = x % 10^k
			push!(res, a, b)
		else
			push!(res, 2024x)
		end
	end
	res
end

for i in 1:75
	input = blink(input)
end

#println(input)
println(length(input))



end
aocmain()
