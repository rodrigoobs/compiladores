%{ 
	#include <stdio.h>
	#include <stdlib.h>
	#include "y.tab.h"
	int yylex(void); 
	void yyerror(char *); 
	extern char *yytext;
	extern FILE *yyin;
	extern int yylineno;
%} 
%token 	KW_CHAR
%token 	KW_INT 
%token 	KW_FLOAT
%token 	KW_IF 
%token 	KW_THEN 
%token 	KW_ELSE 
%token 	KW_WHILE 
%token 	KW_READ 
%token 	KW_RETURN 
%token 	KW_PRINT 
%token 	OPERATOR_LE 
%token 	OPERATOR_GE 
%token 	OPERATOR_EQ 
%token 	OPERATOR_OR 
%token 	OPERATOR_AND 
%token 	OPERATOR_NOT 
%token 	TK_IDENTIFIER 
%token 	LIT_INTEGER 
%token 	LIT_FLOAT 
%token 	LIT_CHAR 
%token 	LIT_STRING 
%token 	TOKEN_ERROR 

%left 	OPERATOR_LE OPERATOR_GE OPERATOR_EQ OPERATOR_OR OPERATOR_AND 
%left	'+' '-'
%left	'*' '/'
 
%% 
program: 
        program expr ';'		  { printf("%d\n", $2); } 
        |
        ; 
expr: 
        LIT_INTEGER               { $$ = $1; } 
        | expr '+' expr           { $$ = $1 + $3; } 
        | expr '-' expr           { $$ = $1 - $3; } 
        ; 
%% 

int yylex();
extern char *yytext;
extern FILE *yyin;

extern int isRunning();
extern void initMe();

void yyerror(char *s) { 
    fprintf(stderr, "line %d: %s\n", yylineno, s);  
} 
int main(int argc, char** argv)
{
	int token;
	
	if (argc < 2)
	{
		fprintf (stderr, "Forneca o nome do arquivo a ser analisado.\n");
		exit (1);
	}
	if (!(yyin = fopen(argv[1], "r")))
	{
		fprintf(stderr, "Erro na abertura do arquivo.\n");
		exit(2);
	}
	
	initMe();

	yyparse();
	return 0;
}

