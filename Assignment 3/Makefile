a.out:	lex.yy.c
		gcc lex.yy.c -lfl

lex.yy.c:	assn3_16CS30044.l assn3_16CS30044_main.c
		flex assn3_16CS30044.l assn3_16CS30044_main.c
        
clean:
		rm a.out lex.yy.c

test:
		./a.out < assn3_16CS30044_test.c