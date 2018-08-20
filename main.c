#include <stdio.h>
#include <stdlib.h>
#include "tokens.h"

int yylex();
extern char *yytext;
extern FILE *yyin;

extern int isRunning();
extern void initMe();

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
	
	while (isRunning())
	{
		token = yylex();
		if (token < 128)
			printf ("%c", token);
		else
		switch(token)
		{
			case KW_CHAR:	printf("[char]");break;
			case KW_INT:	printf("[int]");break;
			case KW_FLOAT:	printf("[float]");break;
			case KW_IF:	printf("[if]");break;
			case KW_THEN:	printf("[then]");break;
			case KW_ELSE:	printf("[else]");break;
			case KW_WHILE:	printf("[while]");break;
			case KW_READ:	printf("[read]");break;
			case KW_RETURN:	printf("[return]");break;
			case KW_PRINT:	printf("[print]");break;

			case OPERATOR_LE:	printf("[<=]");break;
			case OPERATOR_GE:	printf("[>=]");break;
			case OPERATOR_EQ:	printf("[==]");break;

			case OPERATOR_NOT:	printf("[not]");break;
			case OPERATOR_AND:	printf("[and]");break;
			case OPERATOR_OR:	printf("[or]");break;
		
			case TK_IDENTIFIER:	printf("[ID]");break;
			case LIT_INTEGER:	printf("[integer]");break;
			case LIT_FLOAT:		printf("[real]");break;
			case TOKEN_ERROR: 	printf("TOKEN UNKNOWN"); break;
			default:	printf("That wasn't supposed to happen..\n");
		}
		if(!isRunning())
			break;
		
	}
}
