0: func printi starts
1: func printi ends
2: func prints starts
3: func prints ends
4: func readi starts
5: func readi ends
6: func main starts
7: param .LC0
8: t0 = call prints 1
9: t0 = 8
10: t1 = 8
11: n = t1
12: t2 = 0
13: i = t2
14: t3 = 8
15: t1 = 1
16: if i <t3 goto 23
17: t1 = 0
18: goto 30
19: goto 30
20: t4 = i
21: i = i + 1
22: goto 14
23: t5 = 0
24: t5 = t5 * 8
25: t5 = t5 + i
26: t2 = i * i
27: t3 = i + t2
28: arr[t5] = t3
29: goto 20
30: param .LC1
31: t4 = call prints 1
32: t6 = 0
33: i = t6
34: t7 = 8
35: t5 = 1
36: if i <t7 goto 43
37: t5 = 0
38: goto 52
39: goto 52
40: t8 = i
41: i = i + 1
42: goto 34
43: t9 = 0
44: t9 = t9 * 8
45: t9 = t9 + i
46: t6 = arr[t9]
47: param t6
48: t7 = call printi 1
49: param .LC2
50: t8 = call prints 1
51: goto 40
52: param .LC3
53: t9 = call prints 1
54: t10 = 8
55: size = t10
56: t11 = 10
57: t12 = 1
58: max_val = t12
59: t13 = 0
60: t14 = 0
61: t14 = t14 * 10
62: t14 = t14 + t13
63: t15 = 0
64: val[t14] = t15
65: t16 = 1
66: i = t16
67: t10 = 1
68: if i <=n goto 75
69: t10 = 0
70: goto 124
71: goto 124
72: t17 = i
73: i = i + 1
74: goto 67
75: t18 = 1
76: max_val = t18
77: t19 = 0
78: j = t19
79: t11 = 1
80: if j <i goto 87
81: t11 = 0
82: goto 119
83: goto 119
84: t20 = j
85: j = j + 1
86: goto 79
87: t21 = 0
88: t21 = t21 * 8
89: t21 = t21 + j
90: t12 = arr[t21]
91: t13 = i - j
92: t22 = 1
93: t14 = t13 - t22
94: t23 = 0
95: t23 = t23 * 10
96: t23 = t23 + t14
97: t15 = val[t23]
98: t16 = t12 + t15
99: t17 = 1
100: if t16 >max_val goto 104
101: t17 = 0
102: goto 103
103: goto 118
104: t24 = 0
105: t24 = t24 * 8
106: t24 = t24 + j
107: t18 = arr[t24]
108: t19 = i - j
109: t25 = 1
110: t20 = t19 - t25
111: t26 = 0
112: t26 = t26 * 10
113: t26 = t26 + t20
114: t21 = val[t26]
115: t22 = t18 + t21
116: max_val = t22
117: goto 84
118: goto 84
119: t27 = 0
120: t27 = t27 * 10
121: t27 = t27 + i
122: val[t27] = max_val
123: goto 72
124: param .LC4
125: t23 = call prints 1
126: t28 = 0
127: t28 = t28 * 10
128: t28 = t28 + n
129: t24 = val[t28]
130: param t24
131: t25 = call printi 1
132: param .LC5
133: t26 = call prints 1
134: param .LC6
135: t27 = call prints 1
136: err = b
137: param err
138: t28 = call readi 1
139: a = t28
140: t29 = 100
141: t30 = 100
142: t31 = 0
143: i = t31
144: t32 = 100
145: t29 = 1
146: if i <t32 goto 153
147: t29 = 0
148: goto 159
149: goto 159
150: t33 = i
151: i = i + 1
152: goto 144
153: t34 = 0
154: t34 = t34 * 100
155: t34 = t34 + i
156: t35 = 0
157: arr1[t34] = t35
158: goto 150
159: t36 = 0
160: t37 = 0
161: t37 = t37 * 100
162: t37 = t37 + t36
163: t38 = 1
164: arr1[t37] = t38
165: t39 = 0
166: turn = t39
167: t40 = 0
168: i = t40
169: t30 = 1
170: if i <a goto 177
171: t30 = 0
172: goto 327
173: goto 327
174: t41 = i
175: i = i + 1
176: goto 169
177: t42 = 0
178: t31 = 1
179: if turn ==t42 goto 183
180: t31 = 0
181: goto 252
182: goto 321
183: t43 = 0
184: j = t43
185: t44 = 100
186: t32 = 1
187: if j <t44 goto 194
188: t32 = 0
189: goto 200
190: goto 200
191: t45 = j
192: j = j + 1
193: goto 185
194: t46 = 0
195: t46 = t46 * 100
196: t46 = t46 + j
197: t47 = 0
198: arr2[t46] = t47
199: goto 191
200: t48 = 0
201: j = t48
202: t49 = 1
203: t33 = i + t49
204: t34 = 1
205: if j <t33 goto 212
206: t34 = 0
207: goto 321
208: goto 251
209: t50 = j
210: j = j + 1
211: goto 202
212: t51 = 0
213: t51 = t51 * 100
214: t51 = t51 + j
215: t35 = arr1[t51]
216: param t35
217: t36 = call printi 1
218: param .LC7
219: t37 = call prints 1
220: t52 = 0
221: t52 = t52 * 100
222: t52 = t52 + j
223: t53 = 0
224: t53 = t53 * 100
225: t53 = t53 + j
226: t38 = arr2[t53]
227: t54 = 0
228: t54 = t54 * 100
229: t54 = t54 + j
230: t39 = arr1[t54]
231: t40 = t38 + t39
232: arr2[t52] = t40
233: t55 = 1
234: t41 = j + t55
235: t56 = 0
236: t56 = t56 * 100
237: t56 = t56 + t41
238: t57 = 1
239: t42 = j + t57
240: t58 = 0
241: t58 = t58 * 100
242: t58 = t58 + t42
243: t43 = arr2[t58]
244: t59 = 0
245: t59 = t59 * 100
246: t59 = t59 + j
247: t44 = arr1[t59]
248: t45 = t43 + t44
249: arr2[t56] = t45
250: goto 209
251: goto 252
252: t60 = 0
253: j = t60
254: t61 = 100
255: t46 = 1
256: if j <t61 goto 263
257: t46 = 0
258: goto 269
259: goto 269
260: t62 = j
261: j = j + 1
262: goto 254
263: t63 = 0
264: t63 = t63 * 100
265: t63 = t63 + j
266: t64 = 0
267: arr1[t63] = t64
268: goto 260
269: t65 = 0
270: j = t65
271: t66 = 1
272: t47 = i + t66
273: t48 = 1
274: if j <t47 goto 281
275: t48 = 0
276: goto 277
277: goto 320
278: t67 = j
279: j = j + 1
280: goto 271
281: t68 = 0
282: t68 = t68 * 100
283: t68 = t68 + j
284: t49 = arr2[t68]
285: param t49
286: t50 = call printi 1
287: param .LC8
288: t51 = call prints 1
289: t69 = 0
290: t69 = t69 * 100
291: t69 = t69 + j
292: t70 = 0
293: t70 = t70 * 100
294: t70 = t70 + j
295: t52 = arr1[t70]
296: t71 = 0
297: t71 = t71 * 100
298: t71 = t71 + j
299: t53 = arr2[t71]
300: t54 = t52 + t53
301: arr1[t69] = t54
302: t72 = 1
303: t55 = j + t72
304: t73 = 0
305: t73 = t73 * 100
306: t73 = t73 + t55
307: t74 = 1
308: t56 = j + t74
309: t75 = 0
310: t75 = t75 * 100
311: t75 = t75 + t56
312: t57 = arr1[t75]
313: t76 = 0
314: t76 = t76 * 100
315: t76 = t76 + j
316: t58 = arr2[t76]
317: t59 = t57 + t58
318: arr1[t73] = t59
319: goto 278
320: goto 321
321: t77 = 1
322: t60 = t77 - turn
323: turn = t60
324: param .LC9
325: t61 = call prints 1
326: goto 174
327: t78 = 0
328: return t78
329: func main ends