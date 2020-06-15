CC = gcc

all: parser

y.tab.c: parser.y
	byacc -d parser.y

lex.yy.c: scanner.l
	flex scanner.l

parser: lex.yy.c y.tab.c
	$(CC) -o parser lex.yy.c y.tab.c -ll

clean:
	rm lex.yy.c y.tab.h y.tab.c parser

