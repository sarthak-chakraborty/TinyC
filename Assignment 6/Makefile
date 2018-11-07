tinyc: lex.yy.c y.tab.c y.tab.h ass6_16CS30044_translator.h ass6_16CS30044_translator.cxx ass6_16CS30044_target_translator.cxx libmyl.a
	g++ lex.yy.c y.tab.c ass6_16CS30044_translator.cxx ass6_16CS30044_target_translator.cxx -lfl -o tinyc
	
	# Usage: tinyc <file> <executable_name>
	# Or simply "make test" to make executables for all 5 test files


y.tab.h: ass6_16CS30044.y
	yacc -dtv ass6_16CS30044.y 

y.tab.c: ass6_16CS30044.y
	yacc -dtv -Wconflicts-rr -Wother ass6_16CS30044.y 

lex.yy.c: ass6_16CS30044.l y.tab.h
	flex ass6_16CS30044.l

libmyl.a: assn2_16CS30044.o
	ar -rcs libmyl.a assn2_16CS30044.o

assn2_16CS30044.o: assn2_16CS30044.c myl.h
	gcc -Wall -c assn2_16CS30044.c

clean:  
	rm tinyc y.tab.h y.tab.c lex.yy.c y.output test0 test1 test2 test3 test4 test0.s test1.s test2.s test3.s test4.s assn2_16CS30044.o libmyl.a

test:
	#
	#
	#
	# ---------------------------------------
	# generating code for test file 0
	./tinyc < ass6_16CS30044_test0.c  test0
	#
	#
	#
	# ---------------------------------------
	# generating code for test file 1
	./tinyc < ass6_16CS30044_test1.c  test1
	#
	#
	#
	# ---------------------------------------
	# generating code for test file 2
	./tinyc < ass6_16CS30044_test2.c  test2
	#
	#
	#
	# ---------------------------------------
	# generating code for test file 3
	./tinyc < ass6_16CS30044_test3.c  test3
	#
	#
	#
	# ---------------------------------------
	# generating code for test file 4
	./tinyc < ass6_16CS30044_test4.c  test4
	
	# type "./test0 to execute ass6_16CS30044_test0.c file"
	# "similarly type ./test1 ./test2 ./test3 ./test4"

