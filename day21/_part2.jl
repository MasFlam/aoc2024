using Permutations

include("../lib.jl")
function aocmain()


lines = readlines("in.txt")

numpad = [
	'7' '8' '9'
	'4' '5' '6'
	'1' '2' '3'
	'.' '0' 'A'
]
numpadpos = Dict(
	'7' => (1, 1),
	'8' => (1, 2),
	'9' => (1, 3),
	'4' => (2, 1),
	'5' => (2, 2),
	'6' => (2, 3),
	'1' => (3, 1),
	'2' => (3, 2),
	'3' => (3, 3),
	'.' => (4, 1),
	'0' => (4, 2),
	'A' => (4, 3),
)
dirpad = [
	'.' '^' 'A'
	'<' 'v' '>'
]
dirpadpos = Dict(
	'.' => (1, 1),
	'^' => (1, 2),
	'A' => (1, 3),
	'<' => (2, 1),
	'v' => (2, 2),
	'>' => (2, 3),
)

function isokmoves(pad, i, j, moves)
	for move in moves
		if move == '>'
			j += 1
		elseif move == '<'
			j -= 1
		elseif move == '^'
			i -= 1
		elseif move == 'v'
			i += 1
		end
		pad[i, j] == '.' && return false
	end
	true
end
isokmoves_np(i, j, moves) = isokmoves(numpad, i, j, moves)
isokmoves_dp(i, j, moves) = isokmoves(dirpad, i, j, moves)

inftystr = "."^10_000

function solve3(moves)
	S = ""
	
	dp2_i, dp2_j = 1, 3
	for y in moves
		aaa, bbb = dirpadpos[y]
		dddi = dp2_i - aaa
		dddj = dp2_j - bbb
		
		dp3_seq = ""
		
		if dddi > 0
			dp3_seq *= '^' ^ dddi
		else
			dp3_seq *= 'v' ^ -dddi
		end
		
		if dddj > 0
			dp3_seq *= '<' ^ dddj
		else
			dp3_seq *= '>' ^ -dddj
		end
		
		if dddi > 0 && dddj < 0
			dp3_seq = reverse(dp3_seq)
		end
		
		dp3_seq *= 'A'
		
		#println("    To enter $y on dirpad2 you need to press $dp3_seq on dirpad3")
		
		S *= dp3_seq
		
		dp2_i, dp2_j = aaa, bbb
	end
	
	S
end

function nextnext_unpermuted(moves)
	T = ""
	
	dp1_i, dp1_j = 1, 3
	for x in moves
		aa, bb = dirpadpos[x]
		ddi = dp1_i - aa
		ddj = dp1_j - bb
		
		dp2_seq = ""
		
		if ddi > 0
			dp2_seq *= '^' ^ ddi
		else
			dp2_seq *= 'v' ^ -ddi
		end
		
		if ddj > 0
			dp2_seq *= '<' ^ ddj
		else
			dp2_seq *= '>' ^ -ddj
		end
		
		bestS = inftystr
		
		seenperms = Dict{String, String}()
		for perm2 in PermGen(length(dp2_seq))
			dp2_seqperm = dp2_seq[perm2.data]
			dp2_seqperm *= 'A'
			dp2_seqperm in keys(seenperms) && continue
			!isokmoves_dp(dp1_i, dp1_j, dp2_seqperm) && continue
			seenperms[dp2_seqperm] = solve3(dp2_seqperm)
		end
		
		minnextlen = minimum(length.(values(seenperms)))
		
		for (dp2_seqperm, next) in pairs(seenperms)
			length(next) != minnextlen && continue
			
			S = next
			
			if length(S) < length(bestS)
				bestS = S
			end
		end
		
		dp1_i, dp1_j = aa, bb
		
		T *= bestS
	end
	
	T
end

function solve2(moves, depth)
	depth == 0 && return solve3(moves)
	
	T = ""
	
	dp1_i, dp1_j = 1, 3
	for x in moves
		aa, bb = dirpadpos[x]
		ddi = dp1_i - aa
		ddj = dp1_j - bb
		
		dp2_seq = ""
		
		if ddi > 0
			dp2_seq *= '^' ^ ddi
		else
			dp2_seq *= 'v' ^ -ddi
		end
		
		if ddj > 0
			dp2_seq *= '<' ^ ddj
		else
			dp2_seq *= '>' ^ -ddj
		end
		
		bestS = inftystr
		
		seenperms = Dict{String, Int}()
		for perm2 in PermGen(length(dp2_seq))
			dp2_seqperm = dp2_seq[perm2.data]
			dp2_seqperm *= 'A'
			dp2_seqperm in keys(seenperms) && continue
			!isokmoves_dp(dp1_i, dp1_j, dp2_seqperm) && continue
			seenperms[dp2_seqperm] = length(depth > 1 ? nextnext_unpermuted(dp2_seqperm) : solve3(dp2_seqperm))
		end
		
		minnextlen = minimum(values(seenperms))
		
		for (dp2_seqperm, nextlen) in pairs(seenperms)
			nextlen != minnextlen && continue
			
			S = solve2(dp2_seqperm, depth - 1)
			
			if length(S) < length(bestS)
				bestS = S
			end
		end
		
		dp1_i, dp1_j = aa, bb
		
		T *= bestS
	end
	
	T
end

function solvefor(s)
	finalseq = ""
	
	np_i, np_j = 4, 3
	
	for c in s
		a, b = numpadpos[c]
		di = np_i - a
		dj = np_j - b
		
		dp1_seq = ""
		
		if di > 0
			dp1_seq *= '^' ^ di
		else
			dp1_seq *= 'v' ^ -di
		end
		
		if dj > 0
			dp1_seq *= '<' ^ dj
		else
			dp1_seq *= '>' ^ -dj
		end
		
		println("To enter $c on numpad from S you need to press $(dp1_seq)A on dirpad1")
		
		bestseq = inftystr
		
		seenperms = Set{String}()
		for perm in PermGen(length(dp1_seq))
			dp1_seqperm = dp1_seq[perm.data]
			dp1_seqperm in seenperms && continue
			push!(seenperms, dp1_seqperm)
			!isokmoves_np(np_i, np_j, dp1_seqperm) && continue
			dp1_seqperm *= 'A'
			
			T = solve2(dp1_seqperm, 25-1)
			
			if length(T) < length(bestseq)
				bestseq = T
			end
		end
		
		np_i, np_j = a, b
		
		finalseq *= bestseq
	end
	
	length(finalseq)
end

total = 0
for line in lines
	s = line[1:end-1]
	k = solvefor(line)
	println("$s => len=$k")
	total += parse(Int, s) * k
end
println(total)


end
aocmain()
