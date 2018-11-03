0: t0 = 3
1: some_global_variable = t0
2: t1 = 10
3: func printi starts
4: func printi ends
5: func prints starts
6: func prints ends
7: func readi starts
8: func readi ends
9: func main starts
10: param .LC0
11: t0 = call prints 1
12: param .LC1
13: t1 = call prints 1
14: err = c
15: param err
16: t2 = call readi 1
17: a = t2
18: param err
19: t3 = call readi 1
20: b = t3
21: param .LC2
22: t4 = call prints 1
23: param a
24: t5 = call printi 1
25: param .LC3
26: t6 = call prints 1
27: param b
28: t7 = call printi 1
29: param .LC4
30: t8 = call prints 1
31: param .LC5
32: t9 = call prints 1
33: param some_global_variable
34: t10 = call printi 1
35: param .LC6
36: t11 = call prints 1
37: param .LC7
38: t12 = call prints 1
39: t2 = 0
40: return t2
41: func main ends
success