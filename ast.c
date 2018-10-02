#include <stdio.h>
#include <stdlib.h>
#include "hash.h"
#include "ast.h"

AST_NODE* astInsert (int type, HASH_NODE* symbol, AST_NODE* ch0, AST_NODE* ch1, AST_NODE* ch2, AST_NODE* ch3);
{
	AST_NODE* newNode = NULL;
	
	newNode = calloc(1, sizeof(AST_NODE);
	
	newNode->type = type;
	newNode->lineNumber = getLineNumber();
	newNode->symbol = symbol;
	children[0] = ch0;
	children[1] = ch1;
	children[2] = ch2;
	children[3] = ch3;
	
	return newNode;
}
