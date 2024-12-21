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

inftystr = "."^100_000

function solve_dp(moves, depth)
	finalseq = 0
	i, j = 1, 3
	
	for move in moves
		i2, j2 = dirpadpos[move]
		di = i - i2
		dj = j - j2
		
		dp_seq = ""
		
		if di > 0
			dp_seq *= '^' ^ di
		else
			dp_seq *= 'v' ^ -di
		end
		
		if dj > 0
			dp_seq *= '<' ^ dj
		else
			dp_seq *= '>' ^ -dj
		end
		
		bestseq = 1_000_000
		
		for seq in (dp_seq, reverse(dp_seq))
			!isokmoves_np(i, j, seq) && continue
			S = depth > 0 ? solve_dp(seq * 'A', depth-1) : length(seq * 'A')
			if S < bestseq
				bestseq = S
			end
			0 in (di, dj) && break
		end
		
		i, j = i2, j2
		finalseq += bestseq
	end
	
	if depth >= 10
		println("Just finished some depth=$depth")
	end
	
	finalseq
end

function solvefor(s)
	finalseq = 0
	
	i, j = 4, 3
	
	for c in s
		i2, j2 = numpadpos[c]
		di = i - i2
		dj = j - j2
		
		dp_seq = ""
		
		if di > 0
			dp_seq *= '^' ^ di
		else
			dp_seq *= 'v' ^ -di
		end
		
		if dj > 0
			dp_seq *= '<' ^ dj
		else
			dp_seq *= '>' ^ -dj
		end
		
		println("To enter $c on numpad from S you need to press $(dp_seq)A or $(reverse(dp_seq))A on dirpad1")
		
		bestseq = 1_000_000
		
		for seq in (dp_seq, reverse(dp_seq))
			!isokmoves_np(i, j, seq) && continue
			S = solve_dp(seq * 'A', 2-1)
			if S < bestseq
				bestseq = S
			end
			0 in (di, dj) && break
		end
		
		i, j = i2, j2
		
		finalseq += bestseq
	end
	
	finalseq
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
