a.out: lex.yy.o y.tab.o ass5_16CS30044_translator.o
	g++ lex.yy.o y.tab.o ass5_16CS30044_translator.o -lfl

ass5_16CS30044_translator.o: ass5_16CS30044_translator.cxx ass5_16CS30044_translator.h
	g++ -c ass5_16CS30044_translator.h
	g++ -c ass5_16CS30044_translator.cxx

lex.yy.o: lex.yy.c
	g++ -c lex.yy.c

y.tab.o: y.tab.c
	g++ -c y.tab.c

lex.yy.c: ass5_16CS30044.l y.tab.h ass5_16CS30044_translator.h
	flex ass5_16CS30044.l

y.tab.c: ass5_16CS30044.y
	yacc -dtv ass5_16CS30044.y -W

y.tab.h: ass5_16CS30044.y
	yacc -dtv ass5_16CS30044.y -W

clean:
	rm lex.yy.c y.tab.c y.tab.h lex.yy.o y.tab.o ass5_16CS30044_translator.o y.output a.out ass5_16CS30044_translator.h.gch

test: 
	./a.out < ass5_16CS30044_test5.c > ass5_16CS30044_quads5.out
	./a.out < ass5_16CS30044_test3.c > ass5_16CS30044_quads3.out
	./a.out < ass5_16CS30044_test1.c > ass5_16CS30044_quads1.out
	./a.out < ass5_16CS30044_test2.c > ass5_16CS30044_quads2.out
	./a.out < ass5_16CS30044_test4.c > ass5_16CS30044_quads4.out
