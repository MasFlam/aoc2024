#include <algorithm>
#include <climits>
#include <iostream>
#include <string>
#include <vector>
#include <cstdint>
#include <unordered_map>

int intabs(int x) { return x >= 0 ? x : -x; }
int intsgn(int x) { return x > 0 ? 1 : x < 0 ? -1 : 0; }

constexpr size_t infty = size_t(1) << 48;

std::unordered_map<uint64_t, size_t> memo;

size_t solve_dirpad(const std::string &moves, int depth) {
	uint64_t memokey = std::hash<std::string>()(moves) ^ depth;
	if (memo.find(memokey) != memo.end()) {
		return memo[memokey];
	}
	
	char dirpad[2][4] = {
		".^A",
		"<v>",
	};
	
	auto ifor = [](char ch) {
		if (ch == '.') return 0;
		if (ch == '^') return 0;
		if (ch == 'A') return 0;
		if (ch == '<') return 1;
		if (ch == 'v') return 1;
		if (ch == '>') return 1;
	};
	
	auto jfor = [](char ch) {
		if (ch == '.' || ch == '<') return 0;
		if (ch == '^' || ch == 'v') return 1;
		if (ch == 'A' || ch == '>') return 2;
	};
	
	auto areok = [dirpad](const std::string &M, int i, int j) {
		for (char m : M) {
			if (m == '^') --i;
			if (m == 'v') ++i;
			if (m == '<') --j;
			if (m == '>') ++j;
			if (dirpad[i][j] == '.') return false;
		}
		return true;
	};
	
	if (depth == 0) {
//		std::cout << "returning .length()\n";
		return moves.length();
	}
	
	size_t res = 0;
	
	int i = 0;
	int j = 2;
	for (char move : moves) {
		int i2 = ifor(move);
		int j2 = jfor(move);
		
		int di = i - i2;
		int dj = j - j2;
		
		std::string newmoves;
		
		if (di > 0) {
			while (di--) newmoves.push_back('^');
		} else if (di < 0) {
			while (di++) newmoves.push_back('v');
		}
		
		if (dj > 0) {
			while (dj--) newmoves.push_back('<');
		} else if (dj < 0) {
			while (dj++) newmoves.push_back('>');
		}
		
		newmoves.push_back('A');
		
//		std::cout << "  ("<<i<<","<<j<<") -> ("<<i2<<","<<j2<<"): move=" << move << ": newmoves: " << newmoves << '\n';
		
		size_t k;
		
		if (depth == 0) {
			k = newmoves.length();
		} else {
			size_t k1 = infty;
			size_t k2 = infty;
			
			if (areok(newmoves, i, j)) {
				k1 = solve_dirpad(newmoves, depth - 1);
			}
			
			if (i != i2 && j != j2) {
				std::reverse(newmoves.begin(), newmoves.end()-1);
				if (areok(newmoves, i, j)) {
					k2 = solve_dirpad(newmoves, depth - 1);
				}
			}
			
			k = std::min(k1, k2);
		}
		
		res += k;
		
		i = i2;
		j = j2;
	}
	
	if (depth >= 10) {
		std::cout << "Just solved some depth=" << depth << '\n';
	}
	
	return memo[memokey] = res;
}

size_t solve(const std::string &input, int depth) {
	char numpad[4][4] = {
		"789",
		"456",
		"123",
		".0A",
	};
	int i = 3;
	int j = 2;
	
	auto ifor = [](char ch) {
		if (ch == '.') return 3;
		if (ch == '0') return 3;
		if (ch == 'A') return 3;
		if (ch >= '7') return 0;
		if (ch >= '4') return 1;
		if (ch >= '1') return 2;
	};
	
	auto jfor = [](char ch) {
		if (ch == '.' || ch == '1' || ch == '4' || ch == '7') return 0;
		if (ch == '0' || ch == '2' || ch == '5' || ch == '8') return 1;
		if (ch == 'A' || ch == '3' || ch == '6' || ch == '9') return 2;
	};
	
	auto areok = [numpad](const std::string &M, int i, int j) {
		for (char m : M) {
			if (m == '^') --i;
			if (m == 'v') ++i;
			if (m == '<') --j;
			if (m == '>') ++j;
			if (numpad[i][j] == '.') return false;
		}
		return true;
	};
	
	size_t ret = 0;
	
	for (char move : input) {
		int i2 = ifor(move);
		int j2 = jfor(move);
		
		int di = i - i2;
		int dj = j - j2;
		
		std::string moves;
		
		if (di > 0) {
			while (di--) moves.push_back('^');
		} else if (di < 0) {
			while (di++) moves.push_back('v');
		}
		
		if (dj > 0) {
			while (dj--) moves.push_back('<');
		} else if (dj < 0) {
			while (dj++) moves.push_back('>');
		}
		
		moves.push_back('A');
		
//		std::cout << "ch=" << move << ": moves: " << moves << '\n';
		
		size_t k1 = infty;
		size_t k2 = infty;
		
		if (areok(moves, i, j)) {
			k1 = solve_dirpad(moves, depth);
		}
		
		if (i != i2 && j != j2) {
			std::reverse(moves.begin(), moves.end()-1);
			if (areok(moves, i, j)) {
				k2 = solve_dirpad(moves, depth);
			}
		}
		
		ret += std::min(k1, k2);
		
		i = i2;
		j = j2;
	}
	
	return ret;
}

int main() {
	std::string inputs[] {
	//	"029A",
	//	"980A",
	//	"179A",
	//	"456A",
	//	"379A",
		"805A",
		"682A",
		"671A",
		"973A",
		"319A",
	};
	
	size_t total = 0;
	for (auto in : inputs) {
		size_t k = solve(in, 25);
		std::cout << "solve("<<in<<") = " << k << "\n";
		total += k * ((in[0]-'0') * 100 + (in[1]-'0') * 10 + (in[2]-'0'));
	}
	std::cout << "Total = " << total << '\n';
}
