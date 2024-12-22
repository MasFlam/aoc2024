include("../lib.jl")
function aocmain()


lines = readlines("in.txt")
#lines = split("""1
#10
#100
#2024""", '\n')

MASK = 16777215 # 2^24 - 1

function step(x)
	x = xor(x, x << 6)
	x &= MASK
	x = xor(x, x >> 5)
	x &= MASK
	x = xor(x, x << 11)
	x &= MASK
	x
end

total = 0
for line in lines
	x = parse(Int, line)
	for i in 1:2000
		x = step(x)
	end
#	println(x)
	total += x
end
println(total)


end
aocmain()
