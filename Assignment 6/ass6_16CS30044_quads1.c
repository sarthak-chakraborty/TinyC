0: func printi starts
1: func printi ends
2: func prints starts
3: func prints ends
4: func readi starts
5: func readi ends
6: func main starts
7: t0 = 1000
8: t1 = 1000
9: err = c
10: param .LC0
11: t0 = call prints 1
12: param err
13: t1 = call readi 1
14: n = t1
15: t2 = 0
16: i = t2
17: param .LC1
18: t2 = call prints 1
19: param n
20: t3 = call printi 1
21: param .LC2
22: t4 = call prints 1
23: t3 = 0
24: i = t3
25: t5 = 1
26: if i <n goto 33
27: t5 = 0
28: goto 40
29: goto 40
30: t4 = i
31: i = i + 1
32: goto 25
33: t5 = 0
34: t5 = t5 * 1000
35: t5 = t5 + i
36: param err
37: t6 = call readi 1
38: arr[t5] = t6
39: goto 30
40: param .LC3
41: t7 = call prints 1
42: t6 = 0
43: max = t6
44: t7 = 0
45: i = t7
46: t8 = 1
47: if i <n goto 54
48: t8 = 0
49: goto 60
50: goto 60
51: t8 = i
52: i = i + 1
53: goto 46
54: t9 = 0
55: t9 = t9 * 1000
56: t9 = t9 + i
57: t10 = 1
58: lis[t9] = t10
59: goto 51
60: t11 = 1
61: i = t11
62: t9 = 1
63: if i <n goto 70
64: t9 = 0
65: goto 122
66: goto 122
67: t12 = i
68: i = i + 1
69: goto 62
70: t13 = 0
71: j = t13
72: t10 = 1
73: if j <i goto 80
74: t10 = 0
75: goto 67
76: goto 121
77: t14 = j
78: j = j + 1
79: goto 72
80: t15 = 0
81: t15 = t15 * 1000
82: t15 = t15 + i
83: t11 = arr[t15]
84: t16 = 0
85: t16 = t16 * 1000
86: t16 = t16 + j
87: t12 = arr[t16]
88: t13 = 1
89: if t11 >t12 goto 93
90: t13 = 0
91: goto 92
92: goto 108
93: t17 = 0
94: t17 = t17 * 1000
95: t17 = t17 + i
96: t14 = lis[t17]
97: t18 = 0
98: t18 = t18 * 1000
99: t18 = t18 + j
100: t15 = lis[t18]
101: t19 = 1
102: t16 = t15 + t19
103: t17 = 1
104: if t14 <t16 goto 109
105: t17 = 0
106: goto 107
107: goto 108
108: goto 120
109: t20 = 0
110: t20 = t20 * 1000
111: t20 = t20 + i
112: t21 = 0
113: t21 = t21 * 1000
114: t21 = t21 + j
115: t18 = lis[t21]
116: t22 = 1
117: t19 = t18 + t22
118: lis[t20] = t19
119: goto 77
120: goto 77
121: goto 67
122: t23 = 0
123: i = t23
124: t20 = 1
125: if i <n goto 132
126: t20 = 0
127: goto 148
128: goto 148
129: t24 = i
130: i = i + 1
131: goto 124
132: t25 = 0
133: t25 = t25 * 1000
134: t25 = t25 + i
135: t21 = lis[t25]
136: t22 = 1
137: if max <t21 goto 141
138: t22 = 0
139: goto 140
140: goto 147
141: t26 = 0
142: t26 = t26 * 1000
143: t26 = t26 + i
144: t23 = lis[t26]
145: max = t23
146: goto 129
147: goto 129
148: param max
149: t24 = call printi 1
150: param .LC4
151: t25 = call prints 1
152: func main ends
success