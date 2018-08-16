digito		[0-9]
letra		[a-z]|[A-Z]
%{
#define KW_CHAR       256
#define KW_INT        257
#define KW_FLOAT      259
#define KW_IF         261
#define KW_THEN       262
#define KW_ELSE       263
#define KW_WHILE      264
#define KW_FOR        265
#define KW_READ       266
#define KW_RETURN     267
#define KW_PRINT      268

#define OPERATOR_LE   270
#define OPERATOR_GE   271
#define OPERATOR_EQ   272
#define OPERATOR_NE   273
#define OPERATOR_AND  274
#define OPERATOR_OR   275

#define TK_IDENTIFIER 280
#define LIT_INTEGER   281
#define LIT_REAL      282
#define LIT_CHAR      285
#define LIT_STRING    286
#define TOKEN_ERROR   290
%}
%%
"char" 		{return KW_CHAR;}
"int" 		{return KW_INT;}
"float"		{return KW_FLOAT;}
"if" 		{return KW_IF;}
"then" 		{return KW_THEN;}
"else" 		{return KW_ELSE;}
"while"		{return KW_WHILE;}
"for" 		{return KW_FOR;}
"read" 		{return KW_READ;}
"return"	{return KW_RETURN;}
"print"		{return KW_PRINT;}

"<="		{return OPERATOR_LE;}
">="		{return OPERATOR_GE;}
"=="		{return OPERATOR_EQ;}
"!="		{return OPERATOR_NE;}
"&&"		{return OPERATOR_AND;}
"||"		{return OPERATOR_OR;}


{letra}({digito}|{letra})*	{return TK_IDENTIFIER;}
{digito}*			{return LIT_INTEGER;}
{digito}+"."{digito}+		{return LIT_REAL;}


%%
int running = 1;
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
	do{
		switch(tok)
		{
		case KW_CHAR:	printf("[char]");break;
		case KW_INT:	printf("[int]");break;
		case KW_FLOAT:	printf("[float]");break;
		case KW_IF:	printf("[if]");break;
		case KW_THEN:	printf("[then]");break;
		case KW_ELSE:	printf("[else]");break;
		case KW_WHILE:	printf("[while]");break;
		case KW_FOR:	printf("[for]");break;
		case KW_READ:	printf("[read]");break;
		case KW_RETURN:	printf("[return]");break;
		case KW_PRINT:	printf("[print]");break;

		case OPERATOR_LE:	printf("[<=]");break;
		case OPERATOR_GE:	printf("[>=]");break;
		case OPERATOR_EQ:	printf("[==]");break;
		case OPERATOR_NE:	printf("[!=]");break;
		case OPERATOR_AND:	printf("[and]");break;
		case OPERATOR_OR:	printf("[or]");break;
		
		case TK_IDENTIFIER:	printf("[ID]");break;
		case LIT_INTEGER:	printf("[integer]");break;
		case LIT_REAL:		printf("[real]");break;
		default:	printf("fudeu");

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

