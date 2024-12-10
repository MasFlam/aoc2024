include("../lib.jl")
function aocmain()


lines = readlines("in.txt")
input = lines[1]
#input = "2333133121414131402"

disk = Int[]

attype = false # block
nextblid = 0
for i in 1:length(input)
	ch = input[i]
	k = Int(ch - '0')
	if attype == false
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

freeidx = findfirst(x -> x == -1, disk)
for i in reverse(1:n)
	if freeidx === nothing || freeidx >= i
		break
	end
	if disk[i] >= 0
		disk[freeidx] = disk[i]
		disk[i] = -1
		nfi = findnext(x -> x == -1, disk, freeidx)
		freeidx = nfi
	end
end

checksum = BigInt(0)
for i in 1:n
	disk[i] == -1 && break
	pos = i-1
	x = pos * disk[i]
	checksum += BigInt(x)
end

println(checksum)


end
aocmain()
