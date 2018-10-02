typedef struct astNode
{
	int type;
	int lineNumber;
	HASH_NODE* symbol;
	struct astNode* children[MAX_CHILDREN];
	
} AST_NODE;

#define MAX_CHILDREN 4

#define AST_PROGRAM 10
#define AST_PROG_ELEMENTS 11
#define AST_FUNC_DECLARATION 12
#define AST_VAR_DECLARATION 13
#define AST_CMD_LIST 14
#define AST_CMD 15
#define AST_PRINT_LIST 16
#define AST_PARAMETER_LIST 17
#define AST_LIT_LIST 18
#define AST_ARG_LIST 19

#define AST_NAME 20
#define AST_VECTOR 21
#define AST_TYPE 22
#define AST_LITERAL 23

#define AST_ATTRIBUTION 30
#define AST_CMD_BLOCK 31
#define AST_EXPRESSION 32
#define AST_IF 33
#define AST_WHILE 34
#define AST_READ 35
#define AST_PRINT 36
#define AST_RETURN 37
#define AST_SUM 38
#define AST_SUB 39
#define AST_MUL 40
#define AST_DIV 41
#define AST_LT 42
#define AST_GT 43
#define AST_LE 44
#define AST_GE 45
#define AST_EQ 46
#define AST_OR 47
#define AST_AND 48
#define AST_NOT 49
#define AST_EXP_BRACKETS 50
#define AST_FUNC_CALLING 51


AST_NODE* astInsert(int type, HASH_NODE* symbol, AST_NODE* ch0, AST_NODE* ch1, AST_NODE* ch2, AST_NODE* ch3);

void printTree(AST_NODE* root);

void printCode(AST_NODE* root);
