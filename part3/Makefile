CC = gcc

all: codegen

y.tab.c: parser.y
	byacc -d parser.y

lex.yy.c: scanner.l
	flex scanner.l

codegen: lex.yy.c y.tab.c code.c
	$(CC) -o codegen lex.yy.c y.tab.c code.c -ll

clean:
	rm lex.yy.c y.tab.h y.tab.c codegen

