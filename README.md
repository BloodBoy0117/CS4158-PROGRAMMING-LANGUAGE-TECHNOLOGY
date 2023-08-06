# CS4158-PROGRAMMING-LANGUAGE-TECHNOLOGY
Part1 The Lexer

flex lexer.l
gcc lex.yy.c
a.exe

Part2 The Parser

flex lexer.l
bison -d parser.y
gcc lex.yy.c parser.tab.c
a.exe

