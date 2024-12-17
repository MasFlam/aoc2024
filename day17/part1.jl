include("../lib.jl")
function aocmain()


lines = readlines("in.txt")
#lines = split("""Register A: 729
#Register B: 0
#Register C: 0
#
#Program: 0,1,5,4,3,0""", '\n')

sregs, sprog = vsplit(lines, isempty)

initreg = BigInt[big"1", big"2", big"3"]
initreg[1] = parse(BigInt, replace(sregs[1], r"[^0-9-]" => ""))
initreg[2] = parse(BigInt, replace(sregs[2], r"[^0-9-]" => ""))
initreg[3] = parse(BigInt, replace(sregs[3], r"[^0-9-]" => ""))

program = BigInt.(parseints(split(replace(sprog[1], r"[^0-9,-]" => ""), ',')))

function simulate(ra,rb,rc)
	reg = [BigInt(ra), BigInt(rb), BigInt(rc)]
	pc = 1

	function combo()
		operand = program[pc]
		pc += 1
		operand <= 3 && return operand
		operand <= 6 && return reg[operand - 3]
		return nothing
	end

	function literal()
		x = program[pc]
		pc += 1
		x
	end

	function printstate()
		println("A=$(reg[1]) B=$(reg[2]) C=$(reg[3]), pc=$pc")
	end

	outputs = []

	while pc <= length(program)
		#printstate()
		opcode = literal()
		if opcode == 0
			a = reg[1]
			b = big"2" ^ combo()
			reg[1] = div(a, b)
		elseif opcode == 1
			a = reg[2]
			b = literal()
			reg[2] = xor(a,b)
		elseif opcode == 2
			x = combo()
			reg[2] = x % 8
		elseif opcode == 3
			adr = literal()
			reg[1] == 0 && continue
			pc = adr+1
		elseif opcode == 4
			literal()
			a = reg[2]
			b = reg[3]
			reg[2] = xor(a, b)
		elseif opcode == 5
			x = combo()
			push!(outputs, x % 8)
		elseif opcode == 6
			a = reg[1]
			b = big"2" ^ combo()
			reg[2] = div(a, b)
		elseif opcode == 7
			a = reg[1]
			b = big"2" ^ combo()
			reg[3] = div(a, b)
		end
	end
	
	outputs
end

for A in 0:100000000
	outs = simulate(A, 0, 0)
	if outs == program
		println("A = $A")
		break
	end
end


end
aocmain()
