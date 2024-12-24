#include <algorithm>
#include <random>
#include <iostream>
#include <vector>
#include <tuple>
#include <utility>
#include <unordered_map>
using ll = long long;

#define OP_OR  1
#define OP_AND 2
#define OP_XOR 3

std::vector<std::tuple<int,int,int,int>> gates {
{OP_AND, 1, 2, 3},
{OP_AND, 4, 5, 6},
{OP_AND, 7, 8, 9},
{OP_AND, 10, 11, 12},
{OP_OR, 13, 14, 15},
{OP_AND, 16, 17, 18},
{OP_OR, 19, 20, 21},
{OP_XOR, 22, 23, 24},
{OP_XOR, 25, 26, 27},
{OP_AND, 28, 29, 30},
{OP_AND, 31, 32, 33},
{OP_AND, 34, 35, 36},
{OP_OR, 37, 3, 38},
{OP_XOR, 39, 40, 41},
{OP_XOR, 42, 43, 44},
{OP_XOR, 7, 8, 45},
{OP_XOR, 46, 47, 16},
{OP_AND, 48, 49, 50},
{OP_XOR, 51, 52, 53},
{OP_AND, 54, 55, 56},
{OP_XOR, 57, 58, 59},
{OP_AND, 60, 61, 62},
{OP_XOR, 63, 62, 64},
{OP_XOR, 65, 66, 67},
{OP_AND, 68, 41, 69},
{OP_XOR, 70, 38, 65},
{OP_OR, 71, 72, 73},
{OP_AND, 74, 75, 76},
{OP_XOR, 77, 78, 79},
{OP_AND, 52, 51, 80},
{OP_AND, 81, 82, 83},
{OP_XOR, 84, 85, 86},
{OP_AND, 87, 88, 89},
{OP_AND, 90, 91, 92},
{OP_XOR, 93, 94, 63},
{OP_AND, 95, 96, 97},
{OP_AND, 98, 99, 100},
{OP_AND, 101, 21, 102},
{OP_OR, 103, 69, 104},
{OP_AND, 59, 105, 106},
{OP_XOR, 35, 34, 107},
{OP_AND, 40, 39, 103},
{OP_XOR, 32, 31, 108},
{OP_OR, 109, 110, 1},
{OP_OR, 111, 112, 17},
{OP_XOR, 113, 104, 114},
{OP_AND, 115, 116, 117},
{OP_XOR, 118, 119, 120},
{OP_OR, 121, 122, 123},
{OP_OR, 33, 124, 125},
{OP_AND, 126, 127, 128},
{OP_XOR, 129, 130, 81},
{OP_AND, 94, 93, 131},
{OP_AND, 132, 133, 134},
{OP_AND, 135, 136, 137},
{OP_OR, 138, 139, 140},
{OP_XOR, 141, 142, 2},
{OP_XOR, 143, 44, 144},
{OP_XOR, 145, 146, 147},
{OP_XOR, 148, 149, 150},
{OP_AND, 151, 152, 153},
{OP_AND, 154, 155, 156},
{OP_OR, 157, 30, 158},
{OP_OR, 159, 160, 161},
{OP_OR, 162, 80, 163},
{OP_XOR, 99, 98, 95},
{OP_XOR, 28, 29, 23},
{OP_OR, 164, 165, 49},
{OP_XOR, 125, 53, 166},
{OP_AND, 146, 145, 109},
{OP_AND, 167, 168, 169},
{OP_AND, 147, 170, 110},
{OP_OR, 83, 171, 172},
{OP_XOR, 105, 59, 173},
{OP_AND, 174, 175, 176},
{OP_OR, 177, 178, 179},
{OP_AND, 23, 22, 157},
{OP_OR, 92, 76, 180},
{OP_XOR, 5, 4, 84},
{OP_XOR, 2, 1, 181},
{OP_AND, 182, 183, 184},
{OP_AND, 185, 186, 159},
{OP_XOR, 187, 188, 189},
{OP_XOR, 152, 151, 190},
{OP_XOR, 88, 87, 11},
{OP_XOR, 191, 192, 193},
{OP_XOR, 194, 195, 31},
{OP_XOR, 135, 136, 167},
{OP_XOR, 196, 197, 198},
{OP_OR, 6, 199, 182},
{OP_AND, 46, 47, 200},
{OP_XOR, 201, 202, 116},
{OP_XOR, 101, 21, 203},
{OP_OR, 204, 205, 168},
{OP_AND, 206, 140, 207},
{OP_AND, 129, 130, 171},
{OP_OR, 153, 208, 85},
{OP_AND, 158, 189, 112},
{OP_AND, 209, 163, 178},
{OP_AND, 210, 211, 212},
{OP_XOR, 213, 214, 149},
{OP_XOR, 215, 216, 210},
{OP_XOR, 79, 180, 217},
{OP_XOR, 60, 61, 218},
{OP_AND, 219, 220, 221},
{OP_OR, 222, 131, 105},
{OP_OR, 223, 224, 68},
{OP_AND, 143, 44, 225},
{OP_OR, 226, 212, 115},
{OP_AND, 25, 26, 139},
{OP_XOR, 133, 132, 7},
{OP_XOR, 227, 228, 70},
{OP_OR, 229, 225, 170},
{OP_AND, 230, 231, 160},
{OP_AND, 198, 232, 71},
{OP_AND, 233, 234, 235},
{OP_XOR, 174, 175, 236},
{OP_OR, 237, 238, 96},
{OP_AND, 239, 240, 204},
{OP_XOR, 179, 241, 242},
{OP_XOR, 17, 16, 243},
{OP_XOR, 244, 245, 246},
{OP_AND, 66, 65, 247},
{OP_XOR, 248, 249, 250},
{OP_AND, 251, 252, 253},
{OP_XOR, 254, 255, 113},
{OP_OR, 256, 247, 22},
{OP_AND, 257, 258, 259},
{OP_AND, 42, 43, 229},
{OP_AND, 79, 180, 19},
{OP_AND, 194, 195, 124},
{OP_XOR, 95, 96, 260},
{OP_XOR, 27, 261, 262},
{OP_AND, 255, 254, 122},
{OP_OR, 263, 264, 248},
{OP_AND, 77, 78, 20},
{OP_XOR, 265, 266, 267},
{OP_AND, 228, 227, 268},
{OP_OR, 269, 270, 148},
{OP_XOR, 206, 140, 271},
{OP_XOR, 170, 147, 272},
{OP_XOR, 239, 240, 241},
{OP_AND, 197, 196, 72},
{OP_AND, 38, 70, 273},
{OP_OR, 274, 275, 266},
{OP_AND, 149, 148, 164},
{OP_XOR, 81, 82, 276},
{OP_AND, 27, 261, 138},
{OP_AND, 201, 202, 269},
{OP_AND, 249, 248, 13},
{OP_XOR, 277, 15, 278},
{OP_XOR, 186, 185, 279},
{OP_AND, 104, 113, 121},
{OP_XOR, 75, 74, 280},
{OP_AND, 281, 282, 274},
{OP_XOR, 90, 91, 75},
{OP_AND, 107, 172, 263},
{OP_XOR, 257, 258, 48},
{OP_XOR, 283, 284, 249},
{OP_XOR, 285, 286, 265},
{OP_AND, 216, 215, 226},
{OP_XOR, 230, 231, 186},
{OP_XOR, 282, 281, 192},
{OP_XOR, 154, 155, 287},
{OP_XOR, 123, 190, 288},
{OP_AND, 192, 191, 275},
{OP_AND, 63, 62, 222},
{OP_XOR, 163, 209, 289},
{OP_AND, 188, 187, 111},
{OP_OR, 268, 273, 290},
{OP_AND, 291, 292, 256},
{OP_AND, 293, 294, 177},
{OP_XOR, 234, 233, 101},
{OP_XOR, 158, 189, 295},
{OP_XOR, 220, 219, 183},
{OP_OR, 12, 89, 211},
{OP_AND, 142, 141, 37},
{OP_OR, 169, 137, 261},
{OP_XOR, 172, 107, 264},
{OP_AND, 213, 214, 165},
{OP_AND, 296, 297, 238},
{OP_XOR, 55, 54, 298},
{OP_AND, 241, 179, 205},
{OP_OR, 221, 184, 185},
{OP_AND, 53, 125, 162},
{OP_XOR, 68, 41, 299},
{OP_XOR, 11, 10, 300},
{OP_XOR, 182, 183, 301},
{OP_XOR, 126, 127, 155},
{OP_AND, 286, 285, 302},
{OP_XOR, 303, 304, 244},
{OP_OR, 176, 305, 10},
{OP_OR, 259, 50, 245},
{OP_OR, 100, 97, 54},
{OP_AND, 304, 303, 224},
{OP_OR, 156, 128, 232},
{OP_AND, 190, 123, 208},
{OP_AND, 284, 283, 14},
{OP_XOR, 232, 198, 306},
{OP_OR, 200, 18, 32},
{OP_OR, 307, 302, 8},
{OP_OR, 102, 235, 143},
{OP_XOR, 167, 168, 308},
{OP_AND, 73, 236, 305},
{OP_XOR, 296, 297, 277},
{OP_XOR, 48, 49, 309},
{OP_XOR, 210, 211, 310},
{OP_XOR, 73, 236, 311},
{OP_XOR, 115, 116, 270},
{OP_OR, 56, 120, 74},
{OP_AND, 15, 277, 237},
{OP_AND, 58, 57, 312},
{OP_XOR, 294, 293, 209},
{OP_OR, 253, 207, 154},
{OP_AND, 266, 265, 307},
{OP_AND, 119, 118, 55},
{OP_OR, 9, 134, 82},
{OP_XOR, 251, 252, 206},
{OP_AND, 244, 245, 223},
{OP_AND, 84, 85, 199},
{OP_OR, 106, 312, 191},
{OP_XOR, 291, 292, 66},
};

std::vector<int> zbit_nodes {
218,
64,
173,
193,
267,
45,
276,
36,
250,
278,
260,
298,
280,
217,
203,
144,
272,
181,
290,
67,
24,
295,
243,
108,
166,
289,
242,
308,
262,
271,
287,
306,
311,
300,
310,
117,
150,
309,
246,
299,
114,
288,
86,
301,
279,
161,
};

std::vector<int> xbit_nodes {
60,
94,
58,
282,
286,
132,
129,
35,
284,
296,
98,
119,
91,
77,
234,
43,
145,
142,
228,
291,
28,
187,
47,
194,
51,
294,
240,
136,
25,
251,
127,
197,
175,
87,
215,
202,
213,
257,
304,
39,
255,
151,
4,
220,
231,
};

std::vector<int> ybit_nodes {
61,
93,
57,
281,
285,
133,
130,
34,
283,
297,
99,
118,
90,
78,
233,
42,
146,
141,
227,
292,
29,
188,
46,
195,
52,
293,
239,
135,
26,
252,
126,
196,
174,
88,
216,
201,
214,
258,
303,
40,
254,
152,
5,
219,
230,
};

std::unordered_map<int, int> gate_incoming;
std::unordered_map<int, std::string> labels;
std::vector<int> node_values;

std::string mklabel(int a) {
	return std::to_string(a);
}

std::mt19937_64 rng(2137 + 420 * 1337);

bool eval_node(int node) {
	if (node_values[node] == -1) {
		int gateid = gate_incoming[node];
		auto [op, a, b, c] = gates[gateid-1];
		bool x = eval_node(a);
		bool y = eval_node(b);
		bool z = op == OP_OR ? (x||y) : op == OP_AND ? (x&&y) : (x!=y);
		return z;
	} else {
		return node_values[node];
	}
}

int find_first_bad_bit() {
	std::uniform_int_distribution<ll> xydist(0, (1ll << 44) - 1);
	int ntries = 300;
	for (int i = 1; i <= 45; ++i) {
		for (int tr = 0; tr < ntries; ++tr) {
			ll x = xydist(rng);
			ll y = xydist(rng);
			ll z = x + y;
			for (int j = 0; j <= 44; ++j) {
				node_values[xbit_nodes[j]] = ((x >> j) & 1);
				node_values[ybit_nodes[j]] = ((y >> j) & 1);
			}
			bool z1 = eval_node(zbit_nodes[i]);
			bool z0 = (z >> i) & 1;
			if (z0 != z1) return i;
		}
	}
	return -1;
}

int main() {
	int max_node_id = 0;
	
	std::vector<std::pair<int,int>> swaps {
		{12, 179},
		{48, 216},
		{26, 170},
		{47, 209},
	};
	
	for (int i = 0; auto [op, a, b, c] : gates) {
		++i;
		gate_incoming[c] = i;
		max_node_id = std::max({max_node_id, a, b, c});
	}
	
	node_values.assign(max_node_id + 7, -1);
	
	int fbb1 = find_first_bad_bit();
	std::cerr << "First bad bit has index: " << fbb1 << '\n';
	
	std::cerr << "Swaps:\n";
	for (auto [a,b] : swaps) {
		auto &[q,w,e,r] = gates[a-1];
		auto &[z,x,c,v] = gates[b-1];
		std::cerr << "- gate " << a << " with " << b << '\n';
		std::swap(gate_incoming[r], gate_incoming[v]);
		std::swap(r, v);
	}
	
	int fbb2 = find_first_bad_bit();
	std::cerr << "First bad bit has index after swaps: " << fbb2 << '\n';
	
	for (int node = 1; node <= max_node_id; ++node) {
		auto xit = std::find(xbit_nodes.begin(), xbit_nodes.end(), node);
		auto yit = std::find(ybit_nodes.begin(), ybit_nodes.end(), node);
		auto zit = std::find(zbit_nodes.begin(), zbit_nodes.end(), node);
		if      (xit != xbit_nodes.end()) labels[node] = "X_" + mklabel(xit - xbit_nodes.begin());
		else if (yit != ybit_nodes.end()) labels[node] = "Y_" + mklabel(yit - ybit_nodes.begin());
		else if (zit != zbit_nodes.end()) labels[node] = "Z_" + mklabel(zit - zbit_nodes.begin());
		else {
			labels[node] = "" + std::to_string(node);
		}
	}
	
	std::cout << "digraph {\n";
	
	for (int i = 0; auto [op, a, b, c] : gates) {
		++i;
		std::cout << "\t" << labels[a] << " -> " << labels[c] << " [label=\"G" << i << (op==OP_OR ? "or" : op==OP_AND ? "and" : "xor") << "\"];\n";
		std::cout << "\t" << labels[b] << " -> " << labels[c] << " [label=\"G" << i << (op==OP_OR ? "or" : op==OP_AND ? "and" : "xor") << "\"];\n";
	}
	
	std::cout << "}\n";
}
