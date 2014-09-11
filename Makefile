
all: interprete run

interprete:
	flex abc.l
	bison -dv abc.y -o abc_parser.c
	gcc abc_scaner.c abc_parser.c -o abc
clean:
	rm *tab*
	rm lex.yy.c
run: 	
	./abc
