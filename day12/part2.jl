include("../lib.jl")
function aocmain()


lines = readlines("in.txt")
#lines = split("""AAAAAA
#AAABBA
#AAABBA
#ABBAAA
#ABBAAA
#AAAAAA""", '\n')

grid = makegrid(lines, sentinels=true)
n = length(lines)
m = length(lines[1])

vis = falses(n+2, m+2)

function dfs(i, j, ch)
	hsides = []
	vsides = []
	area = 1
	vis[i, j] = true
	for (a, b) in nbors(i, j, diag=false)
		if grid[a, b] != ch
			if a == i
				# horiz
				push!(hsides, (minmax(b, j), i, Int(b > j)))
			else
				# vert
				push!(vsides, (minmax(a, i), j, Int(a > i)))
			end
		elseif !vis[a, b]
			hs, vs, y = dfs(a, b, ch)
			append!(hsides, hs)
			append!(vsides, vs)
			area += y
		end
	end
	hsides, vsides, area
end

total = 0

for i in 1:n
	for j in 1:m
		if !vis[i+1, j+1]
			ch = grid[i+1, j+1]
			hsides, vsides, area = dfs(i+1, j+1, ch)
			
			# was missing a sort!(vsides) here but it passed. maybe the dfs visits the cells in a way that makes it redundant? i don't think so...
			sort!(hsides)
			
			previ = -10
			prevj = -10
			prevb = -1
			hedges = 0
			for ((j1, j2), i, is_j1_j) in hsides
				if j1 != prevj || i != previ + 1 || is_j1_j != prevb
					hedges += 1
				end
				previ = i
				prevj = j1
				prevb = is_j1_j
			end
			
			previ = -10
			prevj = -10
			prevb = -1
			vedges = 0
			for ((i1, i2), j, is_i1_i) in hsides # THIS SHOULD BE vsides OMG somehow it gave the correct answer anyway? wait no, vedges always = hedges actually lol
				if i1 != previ || j != prevj + 1 || is_i1_i != prevb
					vedges += 1
				end
				previ = i1
				prevj = j
				prevb = is_i1_i
			end
			
			nedges = hedges + vedges
			
			total += nedges * area
		end
	end
end

println(total)


end
aocmain()
