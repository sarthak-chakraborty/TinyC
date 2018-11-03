0: func printi starts
1: func printi ends
2: func prints starts
3: func prints ends
4: func readi starts
5: func readi ends
6: func fibo starts
7: t0 = 0
8: t0 = 1
9: if n ==t0 goto 13
10: t0 = 0
11: goto 16
12: goto 37
13: t1 = 0
14: return t1
15: goto 37
16: t2 = 1
17: t1 = 1
18: if n ==t2 goto 22
19: t1 = 0
20: goto 25
21: goto 36
22: t3 = 1
23: return t3
24: goto 25
25: t4 = 1
26: t2 = n - t4
27: param t2
28: t3 = call fibo 1
29: t5 = 2
30: t4 = n - t5
31: param t4
32: t5 = call fibo 1
33: t6 = t3 + t5
34: return t6
35: goto 36
36: goto 37
37: func fibo ends
38: func main starts
39: param .LC0
40: t7 = call prints 1
41: err = c
42: param err
43: t8 = call readi 1
44: a = t8
45: param a
46: t9 = call fibo 1
47: f = t9
48: param .LC1
49: t10 = call prints 1
50: param a
51: t11 = call printi 1
52: param .LC2
53: t12 = call prints 1
54: param f
55: t13 = call printi 1
56: param .LC3
57: t14 = call prints 1
58: t6 = 0
59: return t6
60: func main ends
success