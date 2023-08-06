%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>


extern int yylex();
extern int yyparse();
void yyerror(const char* s);
extern int yylineno;

typedef struct {
   char* name;
   int varsize;
} Var;

Var identifiers[100];
int numVars = 0;

void creatvar(int varsize, char* identifier);
void checkidentifierExist(char* identifier);
void IntToVar(int val, char* identifier);
void VarToVar(char* id1, char* id2);
int indexcheck(char* varName);
%}

%union {int number; int varsize; char* name;}
%start program
%token <name> IDENTIFIER
%token <varsize> Size
%token <number> INTEGER
%token START MAIN END MOVE TO ADD INPUT PRINT SEMICOLON STRING_LITERAL LINE_TERMINATOR


%%
program		: start main end					{ printf("\nProgram is valid.\n"); exit(0); } 
		;
                    
start	: START LINE_TERMINATOR declarations			{ }
		;
                    
declarations	: declarations declaration				{ }
		| 							{ } 
		;
                    
declaration	: Size IDENTIFIER LINE_TERMINATOR			{ creatvar($1, $2); }
		; 
                    
main		: MAIN LINE_TERMINATOR operations			{ }
		;
              	      
operations	: operations operation					{ }
		|							{ }
		
                    
operation	: move | add | input | print				{ }
		;
                   
move		: MOVE IDENTIFIER TO IDENTIFIER LINE_TERMINATOR		{ VarToVar($2, $4); } 
		| MOVE INTEGER TO IDENTIFIER LINE_TERMINATOR		{ IntToVar($2, $4); }
		;
                    
add		: ADD IDENTIFIER TO IDENTIFIER LINE_TERMINATOR		{ VarToVar($2, $4); }
		| ADD INTEGER TO IDENTIFIER LINE_TERMINATOR		{ IntToVar($2, $4); }
		;
		
input		: INPUT input_statement					{ }
		;
                    
input_statement : IDENTIFIER SEMICOLON input_statement			{ checkidentifierExist($1); }
		| IDENTIFIER LINE_TERMINATOR				{ checkidentifierExist($1); }
		;
                    
print		: PRINT print_statement					{ }
		;
                    
print_statement : STRING_LITERAL SEMICOLON print_statement		{ }
		| IDENTIFIER SEMICOLON print_statement			{ checkidentifierExist($1); }
		| STRING_LITERAL LINE_TERMINATOR			{ }
		| IDENTIFIER LINE_TERMINATOR				{ checkidentifierExist($1); }
		;
                                 
end		: END LINE_TERMINATOR					{ } 
		;

%%

int main(){
    while(1){
	printf("-------MyParser-------\n");
	printf("Input here(by keyboard because of the Paste format error):\n");
	printf(">>> \n");
	yyparse();
    }	
}

void creatvar(int varsize, char*  identifier){

    if(indexcheck(identifier) != -1){
    	printf("\nProgram is invalid.\n");
        fprintf(stderr, "Error on line %d: Variable %s already exists\n", yylineno, identifier);
        exit(0);
    }

    numVars++;

    Var var;
    char* temp = (char *) calloc(strlen(identifier)+1, sizeof(char));
    strcpy(temp, identifier);
    var.name = temp;
    var.varsize = varsize;
    identifiers[numVars - 1] = var; 
}

void checkidentifierExist(char* identifier){

    if(indexcheck(identifier) == -1){
    	printf("\nProgram is invalid.\n");
        fprintf(stderr, "Error on line %d: Variable %s does not exist\n", yylineno, identifier);
        exit(0);
    } 
}

void IntToVar(int val, char* identifier){
    int identifierIndex = indexcheck(identifier);
    if(identifierIndex == -1){
    	printf("\nProgram is invalid.\n");
        fprintf(stderr, "Error on line %d: variable %s does not exist\n", yylineno, identifier);
        exit(0);
    }
    else{
        int MaxCapacity = identifiers[identifierIndex].varsize;
        int temp = val;
        int numDigits = 0;
        while(temp != 0){
            temp /= 10;
            numDigits++;
        }
        if(numDigits > MaxCapacity){
        	printf("\nProgram is invalid.\n");
            fprintf(stderr, "Warning on line %d: value %d was too large for variable %s of varsize %d\n", yylineno, val, identifier, MaxCapacity);
            exit(0);
        }
    }
}
void VarToVar(char* id1, char* id2){
    int index_one = indexcheck(id1);
    int index_two = indexcheck(id2);
    
    if(index_one == -1 && index_two != -1){
    	printf("\nProgram is invalid.\n");
        fprintf(stderr, "Error on line %d: Variable %s does not exist\n", yylineno, id1);
        exit(0);
    }
    else if(index_one != -1 && index_two == -1){
    	printf("\nProgram is invalid.\n");
        fprintf(stderr, "Error on line %d: Variable %s does not exist\n", yylineno, id2);
        exit(0);
    }
    else if(index_one == -1 && index_two == -1){
    	printf("\nProgram is invalid.\n");
        fprintf(stderr, "Error on line %d: Variable %s and Variable %s do not exist\n", yylineno, id1, id2);
        exit(0);
    }
    else{
        int varOneSize = identifiers[index_one].varsize;
        int varTwoSize = identifiers[index_two].varsize;
        
        if(varOneSize > varTwoSize){
        	printf("\nProgram is invalid.\n");
            fprintf(stderr, "Warning on line %d: variable %s of varsize %d was too large for variable %s of varsize %d\n", yylineno, id1, varOneSize, id2, varTwoSize);
            exit(0);
        }
    }
}


void yyerror(const char *s) {
	printf("\nProgram is invalid.\n");
    fprintf(stderr, "Error on line %d: %s\n", yylineno, s);
    exit(0);

}

int indexcheck(char * varName){
    
    int i;
    for(i = 0; i < numVars; i++){
        if(identifiers[i].name != NULL){
            if(strcmp(identifiers[i].name, varName) == 0){
                return i;
            }
        }
    }    
    
    return -1;
}
