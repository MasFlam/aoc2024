include("../lib.jl")
function aocmain()


lines = readlines("in.txt")

total = 0

idx = 1
while idx <= length(lines)
	la,lb,lc = lines[idx:idx+2]
	
	ax, ay = parseints(split(replace(la, r"[^,0-9]" => ""), ','))
	bx, by = parseints(split(replace(lb, r"[^,0-9]" => ""), ','))
	px, py = parseints(split(replace(lc, r"[^,0-9]" => ""), ','))
	
	px += 10000000000000
	py += 10000000000000
	
	L = (px * ay - py * ax) / (bx * ay - by * ax)
	K = (px - bx * L) / ax
	
	if isinteger(L) && isinteger(K)
		cost = 3 * Int(K) + Int(L)
		total += cost
	end
	
	idx += 4
end

println(total)


end
aocmain()
