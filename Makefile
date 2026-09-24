all: bcs24

bcs24: lexer.l parser.y
	bison -d parser.y
	flex lexer.l
	gcc lex.yy.c parser.tab.c -o bcs24

clean:
	rm -f lex.yy.c parser.tab.c parser.tab.h bcs24 out