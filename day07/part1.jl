include("../lib.jl")
# no more global scope issues
function aocmain()


lines = readlines("in.txt")

opalph = ['+', '*']

function evalu(xs, ops)
	cum = xs[1]
	for (x, op) in zip(xs[2:end], ops)
		if op == '+'
			cum = cum + x
		elseif op == '*'
			cum = cum * x
		end
	end
	cum
end

total = 0
for line in lines
	linesplit = parseints(replace(line, ":" => ""))
	res = linesplit[1]
	xs = linesplit[2:end]
	
	n = length(xs)
	
	good = false
	bitmask = 0
	while bitmask < 2^(n-1)
		ops = [reverse(bitstring(bitmask))[1:n-1]...] .|> (c -> c == '0' ? '+' : '*')
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
