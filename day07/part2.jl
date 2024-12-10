include("../lib.jl")
# no more global scope issues
function aocmain()


lines = readlines("in.txt")

opalph = ['+', '*']

function evalu(xs, ops)
	cum = BigInt(xs[1])
	for (x, op) in zip(xs[2:end], ops)
		x = BigInt(x)
		if op == '+'
			cum = cum + x
		elseif op == '*'
			cum = cum * x
		elseif op == '|'
			cum = BigInt(10)^ndigits(x) * cum + x
		end
	end
	cum
end

total = BigInt(0)
for line in lines
	linesplit = parseints(replace(line, ":" => ""))
	res = BigInt(linesplit[1])
	xs = linesplit[2:end]
	
	n = length(xs)
	
	good = false
	bitmask = 0
	while bitmask < 3^(n-1)
		foo = bitmask
		ops = []
		for i in 1:n-1
			push!(ops, ['+', '*', '|'][foo % 3 + 1])
			foo = div(foo, 3)
		end
		#println(ops)
		#ops = [reverse(bitstring(bitmask))[1:n-1]...] .|> (c -> c == '0' ? '+' : '*')
		#println(bitstring(bitmask))
		#println(reverse(bitstring(bitmask))[1:n-1])
		#println(ops)
		if evalu(xs, ops) == res
			good = true
			break
		end
		bitmask += 1
	end
	
	if good
		total += res
	end
end
println(total)


end
aocmain()
