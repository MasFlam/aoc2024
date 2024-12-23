include("../lib.jl")
function aocmain()


lines = readlines("in.txt")

graph = Dict{String, Vector{String}}()

function connect(a, b)
	if a in keys(graph)
		push!(graph[a], b)
	else
		graph[a] = [b]
	end
	nothing
end

for line in lines
	a, b = split(line, '-')
	connect(a,b)
	connect(b,a)
end

verts = [keys(graph)...]

function isclique(clq)
	for x in clq
		for y in clq
			x == y && continue
			!(y in graph[x]) && return false
		end
	end
	true
end

vis = Set()

best_clique = []
for a in verts
	for b in graph[a]
		ab = intersect(graph[a], graph[b])
		for c in ab
			abc = intersect(ab, graph[c])
			(sort([a,b,c]) in vis) && continue
			push!(vis, sort([a,b,c]))
			for d in abc
				abcd = intersect(abc, graph[d])
				(sort([a,b,c,d]) in vis) && continue
				push!(vis, sort([a,b,c,d]))
				if length(best_clique) < 4
					best_clique = [a,b,c,d]
				end
				for e in abcd
					abcde = intersect(abcd, graph[e])
					(sort([a,b,c,d,e]) in vis) && continue
					push!(vis, sort([a,b,c,d,e]))
					if length(best_clique) < 5
						best_clique = [a,b,c,d,e]
					end
					for f in abcde
						abcdef = intersect(abcde, graph[f])
						#println("K6")
						(sort([a,b,c,d,e,f]) in vis) && continue
						push!(vis, sort([a,b,c,d,e,f]))
						if length(best_clique) < 6
							best_clique = [a,b,c,d,e,f]
						end
						for g in abcdef
							abcdefg = intersect(abcdef, graph[g])
							#println("K7")
							(sort([a,b,c,d,e,f,g]) in vis) && continue
							push!(vis, sort([a,b,c,d,e,f,g]))
							if length(best_clique) < 7
								best_clique = [a,b,c,d,e,f,g]
							end
							for h in abcdefg
								abcdefgh = intersect(abcdefg, graph[h])
								(sort([a,b,c,d,e,f,g,h]) in vis) && continue
								push!(vis, sort([a,b,c,d,e,f,g,h]))
								if length(best_clique) < 8
									best_clique = [a,b,c,d,e,f,g,h]
								end
								for i in abcdefgh
									abcdefghi = intersect(abcdefgh, graph[i])
									(sort([a,b,c,d,e,f,g,h,i]) in vis) && continue
									push!(vis, sort([a,b,c,d,e,f,g,h,i]))
									if length(best_clique) < 9
										best_clique = [a,b,c,d,e,f,g,h,i]
									end
									for j in abcdefghi
										abcdefghij = intersect(abcdefghi, graph[j])
										(sort([a,b,c,d,e,f,g,h,i,j]) in vis) && continue
										push!(vis, sort([a,b,c,d,e,f,g,h,i,j]))
										if length(best_clique) < 10
											best_clique = [a,b,c,d,e,f,g,h,i,j]
										end
										for k in abcdefghij
											abcdefghijk = intersect(abcdefghij, graph[k])
											(sort([a,b,c,d,e,f,g,h,i,j,k]) in vis) && continue
											push!(vis, sort([a,b,c,d,e,f,g,h,i,j,k]))
											if length(best_clique) < 11
												best_clique = [a,b,c,d,e,f,g,h,i,j,k]
											end
											for l in abcdefghijk
												abcdefghijkl = intersect(abcdefghijk, graph[l])
												(sort([a,b,c,d,e,f,g,h,i,j,k,l]) in vis) && continue
												push!(vis, sort([a,b,c,d,e,f,g,h,i,j,k,l]))
												if length(best_clique) < 12
													best_clique = [a,b,c,d,e,f,g,h,i,j,k,l]
												end
												for m in abcdefghijkl
													abcdefghijklm = intersect(abcdefghijkl, graph[m])
													(sort([a,b,c,d,e,f,g,h,i,j,k,l,m]) in vis) && continue
													push!(vis, sort([a,b,c,d,e,f,g,h,i,j,k,l,m]))
													if length(best_clique) < 13
														best_clique = [a,b,c,d,e,f,g,h,i,j,k,l,m]
													end
													for n in abcdefghijklm
														abcdefghijklmn = intersect(abcdefghijklm, graph[n])
														(sort([a,b,c,d,e,f,g,h,i,j,k,l,m,n]) in vis) && continue
														push!(vis, sort([a,b,c,d,e,f,g,h,i,j,k,l,m,n]))
														println("K14: $(sort([a,b,c,d,e,f,g,h,i,j,k,l,m,n]))")
														if length(best_clique) < 14
															best_clique = [a,b,c,d,e,f,g,h,i,j,k,l,m,n]
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end
println(best_clique)


end
aocmain()
