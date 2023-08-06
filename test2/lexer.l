%{

#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include "parser.tab.h"

char* temp;

%}

%option yylineno
%option caseless

%%

[\t ]+			/* Ignore whitespace */ ;
[\n]+			/* Ignore whitespace */ ;
START	    	{ return START; }
MAIN			{ return MAIN; }
END		    	{ return END; }
MOVE	  		{ return MOVE; }
ADD			    { return ADD; }
TO			    { return TO; }
INPUT			{ return INPUT; }
PRINT			{ return PRINT; }
[Ss]+			{ yylval.varsize = strlen(yytext); return Size; }
(-)?[0-9]+		{ yylval.number = atoi(yytext); return INTEGER; }
[_\A-Za-z][\-A-Za-z0-9]*	{ temp = (char*) calloc(strlen(yytext)+1, sizeof(char)); strcpy(temp, yytext); yylval.name = temp; return IDENTIFIER;}
\"(\\.|[^"\\])*\"	{ return STRING_LITERAL; }
;			{ return SEMICOLON; }
\.			{ return LINE_TERMINATOR; }
.			{ return 0;}

%%

int yywrap(void){
    return 1;
}

