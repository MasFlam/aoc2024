
lines = readlines("in.txt")

count = 0

function is_safe(xs)
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
	return safe
end

for line in lines
	global count
	xs = parse.(Int, split(line))
	safe = false
	n = length(xs)
	for i in 1:n
		xs2 = vcat(xs[begin:i-1], xs[i+1:end])
		safe = safe || is_safe(xs2)
	end
	count += Int(safe)
end

println(count)
