
lines = readlines("in.txt")

rg = r"mul\(([0-9]{1,3}),([0-9]{1,3})\)|do\(\)|don't\(\)"

total = 0

enabled = true

for line in lines
	global total
	global enabled
	for m in eachmatch(rg, line)
		if m.match == "do()"
			enabled = true
		elseif m.match == "don't()"
			enabled = false
		elseif enabled
			total += prod(parse.(Int, m))
		end
	end
end

println(total)
