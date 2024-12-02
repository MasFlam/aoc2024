
lines = readlines("in.txt")

count = 0

for line in lines
	xs = parse.(Int, split(line))
	issorted(reverse(xs)) && (xs = reverse(xs))
	safe = false
	if issorted(xs)
		safe = true
		n = length(xs)
		for i in 2:n
			diff = abs(xs[i] - xs[i-1])
			safe = safe && (3 >= diff >= 1)
		end
	end
	global count
	count += Int(safe)
end

println(count)
