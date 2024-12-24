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
	push!(gates, (x, y, z, op))
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

function formula_for(node, isroot)
	if node in xids || node in yids || (!isroot && node in zids)
		return node, Set([node])
	else
		gateidx = gatesC[node][1]
		a, b, c, op = gates[gateidx]
		L, setL = formula_for(a, false)
		R, setR = formula_for(b, false)
		F = (op, L, R)
		return F, union(setL, setR)
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
	for id in ids
		b = invals[id]
		ret = (ret << 1) | (b ? 1 : 0)
	end
	ret
end

for zid in zids
	formula, inputs = formula_for(zid, true)
	zformulas[zid] = formula
	zinputs[zid] = inputs
	#println("formula for $zid is: $formula with inputs=$inputs")
	println("formula for $zid done")
end

open("formulas.jl", "w") do io
	println(io, zformulas)
end
println("Printed formulas to formulas.jl")


xyids = [xids..., yids...]
NTRIES = 100

for (zbi, zid) in pairs(zids)
	zbi -= 1
	good = true
	for _ in 1:NTRIES
		invals = random_invals(xyids)
		xint = makeint(xids, invals)
		yint = makeint(yids, invals)
		zint = xint + yint
		frm = zformulas[zid]
		zbit = eval_expr(frm, invals)
		zbit_wanted = ((zint >> zbi) & 1) == 1
		if zbit_wanted != zbit
			good = false
			break
		end
	end
	if good
		println("Bit $zbi is good.")
		continue
	end
end

#=
	twos = [keys(vals)...]
	for val in twos
		status[val] = 2
	end

	function calcval(a, b, op)
		if op == "OR"
			vals[a] || vals[b]
		elseif op == "AND"
			vals[a] && vals[b]
		elseif op == "XOR"
			vals[a] != vals[b]
		end
	end
	
	while !isempty(twos)
		x = popfirst!(twos)
		for (a, b, c, op) in get(val_gatesL, x, [])
			status[c] += 1
			status[c] == 2 && (vals[c] = calcval(a, b, op); push!(twos, c))
		end
		for (a, b, c, op) in get(val_gatesR, x, [])
			status[c] += 1
			status[c] == 2 && (vals[c] = calcval(a, b, op); push!(twos, c))
		end
	end

	zbits = []
	for key in sort([keys(vals)...])
		if key[1] == 'z'
			println(key, ": ", vals[key])
			push!(zbits, vals[key])
		end
	end
	
	xbits = []
	for key in sort([keys(vals)...])
		if key[1] == 'x'
			println(key, ": ", vals[key])
			push!(xbits, vals[key])
		end
	end
	
	ybits = []
	for key in sort([keys(vals)...])
		if key[1] == 'y'
			println(key, ": ", vals[key])
			push!(ybits, vals[key])
		end
	end

	bstr = join([bit ? "1" : "0" for bit in reverse(ansbits)])
	println(bstr)
end
=#


end
aocmain()
