all: bcs24

bcs24: lex.yy.c parser.tab.c
	gcc lex.yy.c parser.tab.c -o bcs24

clean:
	rm -f bcs24 out
