include("../lib.jl")
function aocmain()


lines = readlines("in.txt")

foo, bar = vsplit(lines, isempty)

vals = Dict()
for line in foo
	a, b = split(line, ": ")
	b = (b == "1")
	vals[a] = b
end

gates = []
for line in bar
	splat = split(line)
	x = splat[1]
	y = splat[3]
	z = splat[5]
	op = splat[2]
	push!(gates, [x, y, z, op])
end

gatesA = Dict()
gatesB = Dict()
gatesC = Dict()
for (i, (x, y, z, op)) in pairs(gates)
	if x in keys(gatesA)
		push!(gatesA[x], i)
	else
		gatesA[x] = [i]
	end
	if y in keys(gatesB)
		push!(gatesB[y], i)
	else
		gatesB[y] = [i]
	end
	if z in keys(gatesC)
		push!(gatesC[z], i)
	else
		gatesC[z] = [i]
	end
end

xids = ["x" * "$(100 + i)"[2:end] for i in 0:44]
yids = ["y" * "$(100 + i)"[2:end] for i in 0:44]
zids = ["z" * "$(100 + i)"[2:end] for i in 0:45]
zformulas = Dict{String,Any}([zid => nothing for zid in zids])
zinputs = Dict{String,Any}([zid => nothing for zid in zids])
zgates = Dict{String,Vector{Int}}([zid => Int[] for zid in zids])

#println("Loading zformulas...")
#include("formulas.jl")
#println("Done")

function formula_for(node, isroot)
	if node in xids || node in yids || (!isroot && node in zids)
		return node, Set([node]), Set(Int[])
	else
		gateidx = gatesC[node][1]
		a, b, c, op = gates[gateidx]
		L, setL, gL = formula_for(a, false)
		R, setR, gR = formula_for(b, false)
		F = (op, L, R)
		return F, union(setL, setR), union(gL, gR, Set([gateidx]))
	end
end

function evalop(op, a, b)
	if op == "OR"
		a || b
	elseif op == "AND"
		a && b
	elseif op == "XOR"
		a != b
	end
end

function eval_expr(E, invals)
	if E isa Tuple
		op, L, R = E
		L = eval_expr(L, invals)
		R = eval_expr(R, invals)
		return evalop(op, L, R)
	else
		return invals[E]
	end
end

function random_invals(inpset)
	invals = Dict()
	for inp in inpset
		invals[inp] = rand(Bool)
	end
	invals
end

function makeint(ids, invals)
	ret = 0
	for id in reverse(ids)
		b = invals[id]
		ret = (ret << 1) | (b ? 1 : 0)
	end
	ret
end

for zid in zids
	formula, inputs, gateset = formula_for(zid, true)
	zformulas[zid] = formula
	zinputs[zid] = inputs
	zgates[zid] = [gateset...]
	println("formula for $zid done")
end

xyids = [xids..., yids...]
NTRIES = 100

ngates = length(gates)

function swap_gates(i, j)
	outi = gates[i][3]
	outj = gates[j][3]
	gates[i][3] = outj
	gates[j][3] = outi
end

function swap_any_two_out_of(gateidcs)
	k = length(gateidcs)
	swapi = rand(1:k)
	swapj = rand(1:k)
	while swapi == swapj
		swapj = rand(1:k)
	end
	swapi = gateidcs[swapi]
	swapj = gateidcs[swapj]
	swap_gates(swapi, swapj)
	return (swapi, swapj)
end

function check_isgood(zid, zbi)
	good = true
	for _ in 1:NTRIES
		invals = random_invals(xyids)
		xint = makeint(xids, invals)
		yint = makeint(yids, invals)
		#println([invals[k] for k in xids])
		#println(bitstring(xint))
		zint = xint + yint
		frm = zformulas[zid]
		zbit = eval_expr(frm, invals)
		zbit_wanted = ((zint >> zbi) & 1) == 1
		#println("$xint + $yint = $zint; zbit=$zbit, zbit_wanted=$zbit_wanted")
		if zbit_wanted != zbit
			good = false
			break
		end
	end
	good
end

function each_swapij(f, idcs)
	k = length(idcs)
	for swapi in 1:k
		for swapj in swapi+1:k
			swi = idcs[swapi]
			swj = idcs[swapj]
			f(swi, swj)
		end
	end
end

function checkzs(zbi_range, swaps_left, good_gates)
	for zbi in zbi_range
		zid = zids[zbi+1]
		good = check_isgood(zid, zbi)
		if good
			println("Bit $zbi is good.")
			for gidx in zgates[zid]
				push!(good_gates, gidx)
			end
			continue
		else
			println("Bit $zbi is bad!")
			prevzid = zbi == 0 ? nothing : zids[zbi]
			println("$zbi: Formula for $zid: ", zformulas[zid])
			#println("$zbi: Formula for $prevzid: ", zformulas[prevzid])
			#new_used = setdiff(zgates[zid], gates[prevzid])
			println("$zbi: good gates $(100 * length(good_gates) / ngates)% which is $(length(good_gates)) / $ngates")
			swaps_left <= 0 && return false
			bad_gates = setdiff(1:ngates, good_gates)
			k = length(bad_gates)
			println("$zbi: Trying any one swap...")
			swaps_left >= 1 && each_swapij(bad_gates) do swi, swj
				swap_gates(swi, swj)
				if check_isgood(zid, zbi)
					println("$zbi: swapping ($swi, $swj) gate outputs fixed this one bit...")
					if checkzs(zbi+1:45, swaps_left - 1, copy(good_gates))
						println("Found it! having swapped gates $swi, $swj")
						return true
					end
				end
				swap_gates(swi, swj)
			end
			println("$zbi: That was insufficient! so sad... Trying any two swaps...")
			swaps_left >= 2 && each_swapij(bad_gates) do swi, swj
				swap_gates(swi, swj)
				each_swapij(setdiff(bad_gates, [swi, swj])) do swi2, swj2
					swap_gates(swi2, swj2)
					if check_isgood(zid, zbi)
						println("$zbi: swapping ($swi, $swj) and ($swi2,$swj2) gate outputs fixed this one bit...")
						if checkzs(zbi+1:45, swaps_left - 2, copy(good_gates))
							println("Found it! having swapped gates ($swi, $swj) and ($swi2, swj2)")
							return true
						end
					end
					swap_gates(swi2, swj2)
				end
				swap_gates(swi, swj)
			end
			println("$zbi: Two swaps aint enough either... bummer")
			return false
			#swapi, swapj = swap_any_two_out_of(bad_gates)
			#setdiff!(bad_gates, [swapi, swapj])
			#if checkzs(zbi:45, swaps_left - 1)
			#	println("Found it! swapped gates $swapi, $swapj")
			#end
			break
		end
	end
	return true
end

println(checkzs(0:45, 4, Int[]))


end
aocmain()
