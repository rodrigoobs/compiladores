%{ 
	#include <stdio.h>
	#include <stdlib.h>
	#include "hash.h"
	#include "y.tab.h"
	int yylex(void); 
	void yyerror(char *); 
	extern FILE *yyin;
	
	#define SYMBOL_LIT_INT 1
	#define SYMBOL_LIT_FLOAT 2
	#define SYMBOL_LIT_CHAR 3
	#define SYMBOL_LIT_STRING 4
	#define SYMBOL_IDENTIFIER 5

%} 

%union { HASH_NODE* symbol; };

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
%token<symbol>	TK_IDENTIFIER 
%token<symbol>	LIT_INTEGER 
%token<symbol> 	LIT_FLOAT 
%token<symbol>	LIT_CHAR 
%token<symbol>	LIT_STRING 
%token 	TOKEN_ERROR

%type<astNode> AST_PROGRAM 
%type<astNode> AST_PROG_ELEMENTS
%type<astNode> AST_FUNC_DECLARATION
%type<astNode> AST_VAR_DECLARATION
%type<astNode> AST_CMD_LIST
%type<astNode> AST_CMD
%type<astNode> AST_PRINT_LIST
%type<astNode> AST_PARAMETER_LIST
%type<astNode> AST_LIT_LIST
%type<astNode> AST_ARG_LIST

%type<astNode> AST_NAME
%type<astNode> AST_VECTOR
%type<astNode> AST_TYPE
%type<astNode> AST_LITERAL

%type<astNode> AST_ATTRIBUTION
%type<astNode> AST_CMD_BLOCK
%type<astNode> AST_EXPRESSION
%type<astNode> AST_IF
%type<astNode> AST_WHILE
%type<astNode> AST_READ
%type<astNode> AST_PRINT
%type<astNode> AST_RETURN
%type<astNode> AST_SUM
%type<astNode> AST_SUB
%type<astNode> AST_MUL
%type<astNode> AST_DIV
%type<astNode> AST_LT
%type<astNode> AST_GT
%type<astNode> AST_LE
%type<astNode> AST_GE
%type<astNode> AST_EQ
%type<astNode> AST_OR
%type<astNode> AST_AND
%type<astNode> AST_NOT
%type<astNode> AST_EXP_BRACKETS
%type<astNode> AST_FUNC_CALLING

%nonassoc LOWER_THAN_ELSE
%nonassoc KW_ELSE

%left 	'<' '>' OPERATOR_LE OPERATOR_GE OPERATOR_EQ OPERATOR_OR OPERATOR_AND 
%left	'+' '-'
%left	'*' '/'
%left	OPERATOR_NOT
 
%% 
program:
	progrElements							{astInsert(AST_PROGRAM, 0, $1, 0, 0, 0); }
	;

progrElements:
	funcDeclaration progrElements					{astInsert(AST_PROG_ELEMENTS, 0, $1, $2, 0, 0); }
	| varDeclaration progrElements					{astInsert(AST_PROG_ELEMENTS, 0, $1, $2, 0, 0); }
	| {printf("Success!\n");}					{$$ = 0;}
	;

name:
	TK_IDENTIFIER							{astInsert(AST_NAME, $$->symbol, 0, 0, 0, 0); }
	;

vector:
	NAME 'q' EXPRESSION 'p'						{astInsert(AST_VECTOR, 0, $1, $3, 0, 0); }
	;

type:
	KW_CHAR								{astInsert(AST_TYPE, $$->symbol, 0, 0, 0, 0); }
	| KW_INT							{astInsert(AST_TYPE, $$->symbol, 0, 0, 0, 0); }
	| KW_FLOAT							{astInsert(AST_TYPE, $$->symbol, 0, 0, 0, 0); }
	;
	
LITERAL:
	LIT_INTEGER							{astInsert(AST_LITERAL $$->symbol, 0, 0, 0, 0); }
	| LIT_FLOAT							{astInsert(AST_LITERAL $$->symbol, 0, 0, 0, 0); }
	| LIT_CHAR							{astInsert(AST_LITERAL $$->symbol, 0, 0, 0, 0); }
	;
	
	
funcDeclaration:
	TYPE NAME 'd' parameterList 'b' cmd 			{astInsert(AST_FUNC_DECLARATION, 0, $1, $2, $4, $5); };

cmdBlock:
	'{' cmdList '}'							{$$ = $2;}
	;
	
cmdList:
	cmd ;' cmdList							{astInsert(AST_CMD_LIST, 0, $1, $3, 0, 0); }
	|								{$$ = 0; }
	;

cmd:	
	ATTRIBUTION						{$$ = $1; }
	| KW_IF EXPRESSION KW_THEN cmd  LOWER_THAN_ELSE		{astInsert(AST_IF, 0, $1, $2, $4, 0); }
	| KW_IF EXPRESSION KW_THEN cmd KW_ELSE cmd 		{astInsert(AST_IF, 0, $1, $2, $4, $5); }
	| KW_WHILE EXPRESSION cmd 				{astInsert(AST_WHILE, 0, $1, $2, $3, 0); }
	| KW_READ name							{astInsert(AST_READ, 0, $1, $2, 0, 0); }
	| KW_PRINT printList						{astInsert(AST_PRINT, 0, $1, $2, 0, 0); }
	| KW_RETURN EXPRESSION						{astInsert(AST_RETURN, 0, $1, $2, 0, 0); }
	| cmdBlock							{astInsert(AST_CMD_BLOCK, 0, 0, 0, 0, 0); }
	| 								{$$ = 0;}
	;

printList:
	LIT_STRING ',' printList					{astInsert(AST_PRINT_LIST, $$->symbol, $3, 0, 0, 0); }
	| EXPRESSION ',' printList					{astInsert(AST_PRINT_LIST, 0, $1, $3, 0, 0); }
	| LIT_STRING							{astInsert(AST_PRINT_LIST, $$->symbol, 0, 0, 0, 0); }
	| EXPRESSION							{astInsert(AST_PRINT_LIST, 0, $1, 0, 0, 0); }
	;

parameterList:
	TYPE NAME ',' parameterList					{astInsert(AST_PARAMETER_LIST, 0, $1, $2, $4, 0); }
	| type name							{astInsert(AST_PARAMETER_LIST, 0, $1, $2, 0, 0); }
	|								{$$ = 0;}
	;
	
litList:
	LITERAL								{astInsert(AST_LIT_LIST, $$->symbol, 0, 0, 0, 0); }
	| LITERAL litList						{astInsert(AST_LIT_LIST, $$->symbol, $2, 0, 0, 0); }
	;

argList:
	EXPRESSION ',' argList						{astInsert(AST_ARG_LIST, 0, $1, $3, 0, 0); }
	| EXPRESSION							{astInsert(AST_ARG_LIST, 0, 0, 0, 0, 0); }
	|								{$$ = 0;}
	;
		
varDeclaration:
	TYPE NAME '=' EXPRESSION ';'					{astInsert(AST_VAR_DECLARATION, 0, $1, $2, $4, 0); }
	| TYPE NAME 'q' LIT_INTEGER 'p' ';'				{astInsert(AST_VAR_DECLARATION, 0, $1, $2, $4, 0); }
	| TYPE NAME 'q' LIT_INTEGER 'p' ':' litList ';'			{astInsert(AST_VAR_DECLARATION, 0, $1, $2, $4, $7); }
	;
	
ATTRIBUTION
	NAME '=' EXPRESSION						{astInsert(AST_ATTRIBUTION, 0, $1, $3, 0, 0); }
	| VECTOR '=' EXPRESSION						{astInsert(AST_ATTRIBUTION, 0, $1, $3, 0, 0); }
	;

EXPRESSION:
	literal								{astInsert(AST_LITERAL, 0, $1, 0, 0, 0); }
	| name								{astInsert(AST_NAME, 0, $1, 0, 0, 0); }
	| vector							{astInsert(AST_VECTOR, 0, $1, 0, 0, 0); }
	| expression '+' expression					{astInsert(AST_SUM, 0, $1, $3, 0, 0); }
	| expression '-' expression					{astInsert(AST_SUB, 0, $1, $3, 0, 0); }
	| expression '*' expression					{astInsert(AST_MUL, 0, $1, $3, 0, 0); }
	| expression '/' expression					{astInsert(AST_DIV, 0, $1, $3, 0, 0); }
	| expression '<' expression					{astInsert(AST_LT, 0, $1, $3, 0, 0); }
	| expression '>' expression					{astInsert(AST_GT, 0, $1, $3, 0, 0); }
	| expression OPERATOR_LE expression				{astInsert(AST_LE, 0, $1, $3, 0, 0); }
	| expression OPERATOR_GE expression				{astInsert(AST_GE, 0, $1, $3, 0, 0); }
	| expression OPERATOR_EQ expression				{astInsert(AST_EQ, 0, $1, $3, 0, 0); }
	| expression OPERATOR_OR expression				{astInsert(AST_OR, 0, $1, $3, 0, 0); }
	| expression OPERATOR_AND expression				{astInsert(AST_AND, 0, $1, $3, 0, 0); }
	| OPERATOR_NOT expression					{astInsert(AST_NOT, 0, $2, 0, 0, 0); }
	| 'd' expression 'b'						{astInsert(AST_EXP_BRACKETS, 0, $2, 0, 0, 0); }
	| name 'd' argList 'b'						{astInsert(AST_FUNC_CALLING, 0, $1, $3, 0, 0); }
        ; 

%% 

int yylex();
extern FILE *yyin;

extern int isRunning();
extern void initMe();

void yyerror(char *s) { 
	extern int lineNumber;
	fprintf(stderr, "line %d: %s\n", lineNumber, s);
	exit (3);
} 
