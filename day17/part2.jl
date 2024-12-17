include("../lib.jl")
function aocmain()


# length(program) = 16
program = [2,4,1,1,7,5,1,5,4,3,0,3,5,5,3,0]

function low3of(x)
	[
		(x >> 0) & 1,
		(x >> 1) & 1,
		(x >> 2) & 1,
	]
end

function findA(bi, og_abits)
	if bi > 16
		abits = reverse(og_abits .|> (x -> x == -1 ? 0 : x))
		return abits
	end
	
	begi = 1 + 3*(bi-1)
	low3bits = og_abits[begi : begi + 2]
	
	println(" "^bi, "findA(bi=$bi, begi=$begi, abits=$(join(og_abits .|> (x -> x == -1 ? '.' : '0'+x)))")
	
	anses = []
	for low3 in 0:7
		abits = copy(og_abits)
		
		low3bits[1] != -1 && low3of(low3)[1] != low3bits[1] && continue
		low3bits[2] != -1 && low3of(low3)[2] != low3bits[2] && continue
		low3bits[3] != -1 && low3of(low3)[3] != low3bits[3] && continue
		
		abits[begi+0] = low3of(low3)[1]
		abits[begi+1] = low3of(low3)[2]
		abits[begi+2] = low3of(low3)[3]
		
		lhs = xor(program[bi], xor(4,low3))
		k = xor(low3,1)
		# Condition: lhs == (A >> k) % 8
		
		shiftedbits = abits[begi + k : begi + k + 2]
		
		shiftedbits[1] != -1 && low3of(lhs)[1] != shiftedbits[1] && continue
		shiftedbits[2] != -1 && low3of(lhs)[2] != shiftedbits[2] && continue
		shiftedbits[3] != -1 && low3of(lhs)[3] != shiftedbits[3] && continue
		
		abits[begi+k+0] = low3of(lhs)[1]
		abits[begi+k+1] = low3of(lhs)[2]
		abits[begi+k+2] = low3of(lhs)[3]
		
		a = findA(bi+1, abits)
		if !isnothing(a)
			push!(anses, a)
		end
	end
	
	return isempty(anses) ? nothing : minimum(anses)
end

function solve()
	abits = fill(-1, 64)
	a = findA(1, copy(abits))
	if !isnothing(a)
		println("A = $a")
	end
end

solve()


end
aocmain()
