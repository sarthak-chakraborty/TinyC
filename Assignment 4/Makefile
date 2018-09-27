a.out: lex.yy.c y.tab.c asgn4_16CS30044_main.o
	gcc y.tab.c lex.yy.c asgn4_16CS30044_main.o -lfl 


lex.yy.c: asgn4_16CS30044.l
	flex asgn4_16CS30044.l

y.tab.c: asgn4_16CS30044.y
		yacc -dtv asgn4_16CS30044.y

asgn4_16CS30044_main.o: asgn4_16CS30044_main.c
		gcc -c asgn4_16CS30044_main.c

clean:
	rm y.tab.h y.tab.c lex.yy.c asgn4_16CS30044_main.o a.out y.output

test:
	./a.out < asgn4_16CS30044_test.c