CC=gcc
CFLAGS=-Wall -g

all:lex.l lex.h
	flex -o lex.c lex.l 
	$(CC) $(CFLAGS) lex.c -o brainfuck
