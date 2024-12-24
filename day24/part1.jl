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
val_gatesL = Dict()
val_gatesR = Dict()
status = Dict()
for line in bar
	splat = split(line)
	x = splat[1]
	y = splat[3]
	z = splat[5]
	op = splat[2]
	push!(gates, (x, y, z, op))
	status[x] = 0
	status[y] = 0
	status[z] = 0
	if x in keys(val_gatesL)
		push!(val_gatesL[x], (x, y, z, op))
	else
		val_gatesL[x] = [(x, y, z, op)]
	end
	if y in keys(val_gatesR)
		push!(val_gatesR[y], (x, y, z, op))
	else
		val_gatesR[y] = [(x, y, z, op)]
	end
end

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

println(val_gatesL)
println(val_gatesL["y03"])
println(twos)
while !isempty(twos)
	x = popfirst!(twos)
	#println(val_gatesL[x])
	#println(get(val_gatesL, x, []))
	for (a, b, c, op) in get(val_gatesL, x, [])
		status[c] += 1
		status[c] == 2 && (vals[c] = calcval(a, b, op); push!(twos, c))
	end
	for (a, b, c, op) in get(val_gatesR, x, [])
		status[c] += 1
		status[c] == 2 && (vals[c] = calcval(a, b, op); push!(twos, c))
	end
end

ansbits = []
for key in sort([keys(vals)...])
	if key[1] == 'z'
		println(key, ": ", vals[key])
		push!(ansbits, vals[key])
	end
end

bstr = join([bit ? "1" : "0" for bit in reverse(ansbits)])
println(bstr)




end
aocmain()
