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
	
	cheapest = 10^6
	for i in 1:100
		for j in 1:100
			rx = i * ax + j * bx
			ry = i * ay + j * by
			if (px,py) == (rx,ry)
				cheapest = min(cheapest, 3i + j)
			end
		end
	end
	
	if cheapest < 10^6
		total += cheapest
	end
	
	idx += 4
end

println(total)


end
aocmain()
