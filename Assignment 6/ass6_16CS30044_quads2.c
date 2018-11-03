0: func printi starts
1: func printi ends
2: func prints starts
3: func prints ends
4: func readi starts
5: func readi ends
6: func main starts
7: param .LC0
8: t0 = call prints 1
9: t0 = 6
10: t1 = 6
11: t2 = 0
12: i = t2
13: t3 = 6
14: t1 = 1
15: if i <t3 goto 22
16: t1 = 0
17: goto 38
18: goto 38
19: t4 = i
20: i = i + 1
21: goto 13
22: t5 = 0
23: t5 = t5 * 6
24: t5 = t5 + i
25: t2 = i * i
26: t3 = i + t2
27: s[t5] = t3
28: t6 = 0
29: t6 = t6 * 6
30: t6 = t6 + i
31: t7 = 2
32: t4 = t7 * i
33: t5 = i * i
34: t6 = t5 * i
35: t7 = t4 + t6
36: f[t6] = t7
37: goto 19
38: param .LC1
39: t8 = call prints 1
40: t8 = 0
41: i = t8
42: t9 = 6
43: t9 = 1
44: if i <t9 goto 51
45: t9 = 0
46: goto 60
47: goto 60
48: t10 = i
49: i = i + 1
50: goto 42
51: t11 = 0
52: t11 = t11 * 6
53: t11 = t11 + i
54: t10 = s[t11]
55: param t10
56: t11 = call printi 1
57: param .LC2
58: t12 = call prints 1
59: goto 48
60: param .LC3
61: t13 = call prints 1
62: t12 = 0
63: i = t12
64: t13 = 6
65: t14 = 1
66: if i <t13 goto 73
67: t14 = 0
68: goto 82
69: goto 82
70: t14 = i
71: i = i + 1
72: goto 64
73: t15 = 0
74: t15 = t15 * 6
75: t15 = t15 + i
76: t15 = f[t15]
77: param t15
78: t16 = call printi 1
79: param .LC4
80: t17 = call prints 1
81: goto 70
82: t16 = 6
83: n = t16
84: param .LC5
85: t18 = call prints 1
86: t17 = 0
87: i = t17
88: param i
89: t19 = call printi 1
90: param .LC6
91: t20 = call prints 1
92: t18 = 1
93: j = t18
94: t21 = 1
95: if j <n goto 102
96: t21 = 0
97: goto 122
98: goto 122
99: t19 = j
100: j = j + 1
101: goto 94
102: t20 = 0
103: t20 = t20 * 6
104: t20 = t20 + j
105: t22 = s[t20]
106: t21 = 0
107: t21 = t21 * 6
108: t21 = t21 + i
109: t23 = f[t21]
110: t24 = 1
111: if t22 >=t23 goto 115
112: t24 = 0
113: goto 114
114: goto 121
115: param j
116: t25 = call printi 1
117: param .LC7
118: t26 = call prints 1
119: i = j
120: goto 99
121: goto 99
122: t22 = 0
123: return t22
124: func main ends
success
