CC = gcc


all: scanner

lex.yy.c: scanner.l
	flex scanner.l

scanner: lex.yy.c
	$(CC) -o scanner lex.yy.c -ll

clean:
	rm lex.yy.c scanner
