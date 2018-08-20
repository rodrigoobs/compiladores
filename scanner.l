%{
	#include "tokens.h"
	#include "hash.h"
	int lineNumber, running;
%}
digito		[0-9]
letra		[a|c|[e-o]|[r-z]|[A-Z]]
caracterEspecial [,|;|:|b|d|p|q|{|}|+|-|*|/|<|>|=|!|&|$|#]
%x COMMENT


%%
"char" 				{return KW_CHAR;}
"int" 				{return KW_INT;}
"float"				{return KW_FLOAT;}
"if" 				{return KW_IF;}
"then" 				{return KW_THEN;}
"else" 				{return KW_ELSE;}
"while"				{return KW_WHILE;}
"read" 				{return KW_READ;}
"return"			{return KW_RETURN;}
"print"				{return KW_PRINT;}

"or"				{return OPERATOR_OR;}
"and"				{return OPERATOR_AND;}
"not"				{return OPERATOR_NOT;}

"<="				{return OPERATOR_LE;}
">="				{return OPERATOR_GE;}
"=="				{return OPERATOR_EQ;}

{caracterEspecial}		{return yytext[0];}

"\n"				{lineNumber++; printf("\n%3d: ",lineNumber);}

{digito}+			{hashInsert(LIT_INTEGER, yytext); return LIT_INTEGER;}
{digito}+"."{digito}+		{hashInsert(LIT_FLOAT, yytext); return LIT_FLOAT;}
({digito}|{letra}|"_")+		{hashInsert(TK_IDENTIFIER, yytext); return TK_IDENTIFIER;}

\"([^(\\.)\"]|\\.)*\"		{hashInsert(LIT_STRING, yytext); return LIT_STRING;}
"'"("\\".|[^'\n])"'"		{hashInsert(LIT_CHAR, yytext); return LIT_CHAR;}

"/*" {BEGIN (COMMENT);}
<COMMENT>\n 			{lineNumber++; printf("\n%3d: COMMENT", lineNumber);}		
<COMMENT>.
<COMMENT>"*/" 			{BEGIN (INITIAL);}

.*				{return TOKEN_ERROR;}

%%
void initMe()
{
	running = 1;
}

int isRunning()
{
	return running;
}

int getLineNumber()
{
	return lineNumber;
}

int main(int argc, char **argv)
{
	if( argc < 2 )
	{
		perror("a.out file_name\n");
		exit(1);
	}
	if((yyin = fopen(argv[1],"r"))==0)
	{
		perror("file not found\n");
		exit(2);
	}
	int tok = yylex();
	printf("%3d: ",lineNumber);
	do{
		if(tok < 128)
		{
			printf("%c",tok);
		}else
		{
		switch(tok)
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
			default:	printf("fudeu");
			}
		}

		tok = yylex();
	}while(running);
	return 0;
}

int yywrap()
{	
	running = 0;
	return 1;
}

