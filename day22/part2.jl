include("../lib.jl")
function aocmain()


lines = readlines("in.txt")
#lines = split("""1
#2
#3
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

n = length(lines)
P = [Int[] for i in 1:n]
PD = [Int[] for i in 1:n]

for (line, i) in zip(lines, 1:n)
	x = parse(Int, line)
	prices = Int[x%10]
	pricediffs = Int[]
	for j in 1:2000
		y = x
		x = step(x)
		push!(pricediffs, x%10 - y%10)
		push!(prices, x%10)
	end
	P[i] = prices
	PD[i] = pricediffs
end

seq2best = Dict()

D = [Dict() for i in 1:n]

for i in 1:n
#	println("i=$i")
	dct = Dict()
	for j in 4:2000
		sub = PD[i][j-3:j]
		prc = P[i][j+1]
		if !(sub in keys(dct))
			dct[sub] = prc
			if sub in keys(seq2best)
				seq2best[sub] += prc
			else
				seq2best[sub] = prc
			end
		end
#		if sub == [-2,1,-1,3]
#			println("bingo! $prc")
#		end
	end
	D[i] = dct
	#println("D[$i][[-2,1,-1,3]] = $(D[i][[-2,1,-1,3]])")
end
#println("seq2best[[-2,1,-1,3]] = $(seq2best[[-2,1,-1,3]])")

answer = maximum(values(seq2best))
println(answer)


end
aocmain()
