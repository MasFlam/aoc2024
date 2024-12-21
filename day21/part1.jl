using Permutations

include("../lib.jl")
function aocmain()


lines = readlines("in.txt")
#=lines = split("""029A
980A
179A
456A
379A""", '\n')=#

#=function solvefor(s)
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
	dirpadpath = Dict(
		'.' => Dict('<'=>2, '>'=>2, '^'=>0, 'v'=>0),
		'^' => Dict('<'=>1, '>'=>1, '^'=>0, 'v'=>0),
		'A' => Dict('<'=>0, '>'=>0, '^'=>0, 'v'=>0),
		'<' => Dict('<'=>2, '>'=>2, '^'=>1, 'v'=>1),
		'v' => Dict('<'=>1, '>'=>1, '^'=>1, 'v'=>1),
		'>' => Dict('<'=>0, '>'=>0, '^'=>1, 'v'=>1),
	)
	
	dp3_len = 0
	
	np_i, np_j = 4, 3
	
	for c in s
		a, b = numpadpos[c]
		di = np_i - a
		dj = np_j - b
		
		dp1_cnt = Dict('<'=>0, '>'=>0, '^'=>0, 'v'=>0)
		
		if di > 0
			dp1_cnt['^'] = di
		else
			dp1_cnt['v'] = -di
		end
		
		if dj > 0
			dp1_cnt['<'] = dj
		else
			dp1_cnt['>'] = -dj
		end
		
		println("char $c in S: dp1_cnt=$(dp1_cnt)")
		
		len_thischar = 0
		
		for (x, k) in pairs(dp1_cnt)
			dp2_cnt = dirpadpath[x]
			println(" char $x times $k for $c: dp2_cnt=$(dp2_cnt) + 1 to accept")
			len_dp2 = 0
			for (y, l) in pairs(dp2_cnt)
				# 2* coz 'A's
				len_dp3 = sum(h for (z, h) in dirpadpath[y])
				println("  char $y times $l for $x: dp3_cnt=$(dirpadpath[y]), len_dp3=$len_dp3")
				len_dp2 += l * (len_dp3 + 1) # +1 coz 'A'
			end
			len_thischar += k * (len_dp2 + 1) # +1 coz 'A'
		end
		
		len_thischar += 1 # +1 coz 'A'
		
		dp3_len += len_thischar
		np_i, np_j = a, b
	end
	
	dp3_len
end=#

function solvefor(s)
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
			else
				i += 1
			end
			pad[i, j] == '.' && return false
		end
		true
	end
	isokmoves_np(i, j, moves) = isokmoves(numpad, i, j, moves)
	isokmoves_dp(i, j, moves) = isokmoves(dirpad, i, j, moves)
	
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
		
		bestseq = "."^1000
		
		for perm in PermGen(length(dp1_seq))
			dp1_seqperm = dp1_seq[perm.data]
			!isokmoves_np(np_i, np_j, dp1_seqperm) && continue
			
			dp1_seqperm *= 'A'
			
			T = ""
			
			dp1_i, dp1_j = 1, 3
			for x in dp1_seqperm
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
				
				#println("  To enter $x on dirpad1 you need to press $(dp2_seq)A on dirpad2")
				
				bestS = "."^1000
				
				for perm2 in PermGen(length(dp2_seq))
					dp2_seqperm = dp2_seq[perm2.data]
					!isokmoves_dp(dp1_i, dp1_j, dp2_seqperm) && continue
					
					S = ""
					
					dp2_seqperm *= 'A'
					
					dp2_i, dp2_j = 1, 3
					for y in dp2_seqperm
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
					
					if length(S) < length(bestS)
						bestS = S
					end
				end
				
				dp1_i, dp1_j = aa, bb
				
				T *= bestS
#				if length(bestS) < length(bestBestS)
#					bestBestS = bestS
#				end
			end
			
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
