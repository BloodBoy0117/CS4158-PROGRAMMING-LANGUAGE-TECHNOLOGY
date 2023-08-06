%{

#include <string.h>
#include <stdlib.h>

void CaculateRange(char* str, char* yytext);

%}

%option noyywrap
%option caseless

%%
[\t ]+ 			/* Ignore whitespace */ ;
[\n]+ 			/* Ignore whitespace */ ;			
        
MAIN     	|                   
MOVE     	|         
ADD      	|  
TO	 	    |       
INPUT    	|   
START   	| 	 
PRINT			{ printf("The %s is a valid KEYWORD\n", yytext); } 
END         	{ printf("End of Input"); exit(0);}       
[Ss]+			{ CaculateRange("The INPUT is", yytext); }
(-)?[0-9]+		{ printf("The %s is an INTEGER\n", yytext); }
[_\A-Za-z][\-A-Za-z0-9]*	{ printf("The %s is an IDENTIFIER\n", yytext);}//[_][\A-Za-z][\-A-Za-z0-9]*
\"(\\.|[^"\\])*\"	{ printf("The %s is a STRING\n", yytext); }
;			{ printf("The %s is a SEMICOLON\n", yytext); }
\.			{ printf("The %s is a LINE_TERMINATOR\n", yytext); }
.			{ printf("The %s is an Invalid Syntax\n", yytext); }

%%

int main(){
	
     yylex();

}

void CaculateRange(char* str, char* yytext){
	long int MaxNum = 9;
	int length = strlen(yytext);
	for(int i = 1; i < length; i++)
	{
		MaxNum = (MaxNum * 10) + 9;
	}
    	printf("%s: %s. The integers can be defined from 0 to %ld\n", str, yytext, MaxNum);
}