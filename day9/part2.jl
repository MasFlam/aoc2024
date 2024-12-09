include("../lib.jl")
function aocmain()


lines = readlines("in.txt")
input = lines[1]
#input = "2333133121414131402"

disk = Int[]

files = []

attype = false # block
nextblid = 0
for i in 1:length(input)
	ch = input[i]
	k = Int(ch - '0')
	if attype == false
		push!(files, (nextblid, length(disk) + 1, k))
		for j in 1:k
			push!(disk, nextblid)
		end
		nextblid += 1
		attype = true
	else
		for j in 1:k
			push!(disk, -1)
		end
		attype = false
	end
end

n = length(disk)

nfiles = length(files)

for (fid, fpos, flen) in reverse(files)
	i = findfirst(x -> x == -1, disk)
	while !isnothing(i) && i < fpos
		slotlen = 0
		for j in i:n
			if disk[j] == -1
				slotlen += 1
			else
				break
			end
		end
		
		if slotlen >= flen
			for j in i:i+flen-1
				disk[j] = fid
			end
			for j in fpos:fpos+flen-1
				disk[j] = -1
			end
			break
		end
		
		i = findnext(x -> x == -1, disk, i+slotlen)
	end
#	println(disk)
end

#println(disk)

checksum = BigInt(0)
for i in 1:n
	disk[i] == -1 && continue
	pos = i-1
	x = pos * disk[i]
	checksum += BigInt(x)
end

println(checksum)


end
aocmain()
