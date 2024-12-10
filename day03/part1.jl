
lines = readlines("in.txt")

rg = r"mul\(([0-9]{1,3}),([0-9]{1,3})\)"

total = 0

for line in lines
	global total
	for m in eachmatch(rg, line)
		total += prod(parse.(Int, m))
	end
end

println(total)
