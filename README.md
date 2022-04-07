# Programming Languages and Compilers
## Programming assignment 1

<div style="page-break-after: always;"></div>

### Description
>Use lex (or flex) and yacc (or bison) to implement a front end (including a lexical analyzer and a syntax recognizer) of the compiler for the MiniJ programming language, which is a simplified version of Java especially designed for a compiler construction project by Professor Chung Yung.
>* See an attached file for the MiniJ lexical rules and grammar rules in details. 
>*  You are requested to separate the C code, the Lex specification, the Yacc
specification into separated files.

### What to do
* Write a lex specification *minij_lex.l*.
* Write a yacc specification *minij_parse.y*.
* Write a main function *minij.c*
* Write a header file *minij.h*.


### Suggested Process
1. Use **bison** to compile *minijparse.y* into *minijparse.c*. The -d switch produces a header file *minijparse.h*.
2. Use **flex** to compile *minijlex.l* into *minijlex.c*.
3. Use **gcc** to compile *minijlex.c* into *minijlex.o*, *minjparse.c* into *minijparse.o*, and *minij.c* *into minij.o*.
4. Use **gcc** to *link minij.o*, *minijlex.o*, and *minijparse.o* into minijparse.

### Software Required
* Flex 2.5.4
* Bison 2.4.1
* MinGW 4.6.2

### Notes

* DO NOT install both MinGW and DevC.
* Check and set up environment variables. 
* Rebooting after installation is suggested.
* Check whether C:\MinGW\bin is in PATH. If not, add it into PATH, using ; as separators.
* In case of using DevC, check for C:\Dev-Cpp\bin instead.

### How to write the program

> * Write a *minij_lex.l* according to the MiniJ lexicons.
> * Write a *minij_parse.y* according to the MiniJ grammar.
> * Build *mjparse* and run ./mjparse test3.mj
1. Writing the minij_lex.l according to the MiniJ lexicons.
 
```
%{
#include "minij.h"
#include "minij_parse.h"
%}

ID  [A-Za-z][A-Za-z0-9_]*
LIT [0-9][0-9]*
NONNL [^\n]
%option yylineno

%%



class			{return CLASS;}
public			{return PUB;}
static			{return STATIC;}
String			{return STR;}
void			{return VOID;}
main			{return MAIN;}
int			{return INT;}
if			{return IF;}
else			{return ELSE;}
while			{return WHILE;}
new			{return NEW;}
return			{return RETURN;}
this			{return THIS;}
true			{return TRUE;}
false			{return FALSE;}
"&&"			{return AND;}
"<"			{return LT;}
"<="			{return LE;}
"+"			{return ADD;}
"-"			{return MINUS;}
"*"			{return TIMES;}
"("			{return LP;}
")"			{return RP;}
"{"			{return LBP;}
"}"			{return RBP;}
","			{return COMMA;}
"."			{return DOT;}
"System.Out.println"	{return PRINT;}
"||"			{return OR;}
"=="			{return EQ;}
"["			{return LSP;}
"]"			{return RSP;}
";" 			{return SEMI;}
"="			{return ASSIGN;}
"//"{NONNL}*[\n]		{/* skip COMMENT */;}
{ID}			{return ID;}
{LIT}			{return LIT;}

[ \t\n]			{/* skip BLANK */}
.			{/* skip redundant characters */}

%%

int yywrap() {return 1;}
```

2. Writing a minij_parse.y according to the MiniJ grammar.
```
%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "minij.h"
	#include "minij_parse.h"
	extern int yylineno;

%}


%token CLASS PUB STATIC
%left  AND OR NOT
%left  LT LE EQ
%left  ADD MINUS
%left  TIMES
%token LBP RBP LSP RSP LP RP
%token INT
%token IF ELSE
%token WHILE PRINT
%token ASSIGN
%token VOID MAIN STR
%token RETURN
%token SEMI COMMA
%token THIS NEW DOT
%token ID LIT TRUE FALSE
%token COMMENT
%token BOOLEAN


%expect 24

%%
prog	:	mainc cdcls
		{ printf("Program -> MainClass ClassDecl*\n");
		  printf("Parsed OK!\n"); }
	|
		{ printf("****** Parsing failed!\n"); }	
	;

mainc	:	CLASS ID LBP PUB STATIC VOID MAIN LP STR LSP RSP ID RP LBP stmts RBP RBP
		{ printf("MainClass -> class id lbp public static void main lp string lsp rsp id rp lbp Statemet* rbp rbp\n"); }
	;

cdcls	:	cdcl cdcls
		{ printf("(for ClassDecl*) cdcls : cdcl cdcls\n"); }
	|
		{ printf("(for ClassDecl*) cdcls : \n"); }
	;

cdcl	:	CLASS ID LBP vdcls mdcls RBP
		{ printf("ClassDecl -> class id lbp VarDecl* MethodDecl* rbp\n"); }
	;

vdcls	:	vdcl vdcls
		{ printf("(for VarDecl*) vdcls : vdcl vdcls\n"); }
	|
		{ printf("(for VarDecl*) vdcls : \n"); }
	;

vdcl	:	type ID SEMI
		{ printf("VarDecl -> Type id semi\n"); }
	;

mdcls	:	mdcl mdcls
		{ printf("(for MethodDecl*) mdcls : mdcl mdcls\n"); }
	|
		{ printf("(for MethodDecl*) mdcls : \n"); }
	;

mdcl	:	PUB type ID LP formals RP LBP vdcls stmts RETURN exp SEMI RBP
		{ printf("MethodDecl -> public Type id lp FormalList rp lbp Statements* return Exp semi rbp\n"); }
	;

formals	:	type ID frest
		{ printf("FormalList -> Type id FormalRest*\n"); }
	|
		{ printf("FormalList -> \n"); }
	;

frest	:	COMMA type ID frest
		{ printf("FormalRest -> comma Type id FormalRest\n"); }
	|
		{ printf("FormalRest -> \n"); }
	;

type	:	INT LSP RSP
		{printf("type -> int lsp rsp\n"); }
	|	
		BOOLEAN
		{printf("type -> boolean\n"); }
	|	
		INT
		{printf("type -> int\n"); }
	|	
		ID
		{printf("type -> id\n"); }
	;


stmts   : stmt stmts
	{ printf("(Statement*) stmts : stmt stmts \n");} 
	|
	{ printf("(Statement*) stmts : \n");} 
	;



stmt	:	LBP stmts RBP
		{printf("Statement -> lbp Statement* rbp\n"); }
	|
		IF LP exp RP stmt ELSE stmt
		{printf("Statement -> if lp Exp rp Statement else Statement\n"); }
	|
		WHILE LP exp RP stmt
		{printf("Statement -> while lp Exp rp Statement\n"); }
	|
		PRINT LP exp RP SEMI
		{printf("Statement -> while lp Exp rp semi\n"); }
	|
		ID ASSIGN exp SEMI 
		{printf("Statement -> id assign Exp semi\n"); }
	|
		ID LSP exp RSP ASSIGN exp SEMI
		{printf("Statement -> id lsp Exp rsp assign Exp semi"); }
	|
		vdcl
		{printf("Statement -> id lsp Exp rsp assign Exp semi"); }
	;

exp	: 	exp ADD exp
		{printf("Exp -> Exp add Exp\n"); }
	|
		exp MINUS exp
		{printf("Exp -> Exp minus Exp\n"); }
	|
		exp TIMES exp
		{printf("Exp -> Exp times Exp\n"); }
	|
		exp AND exp
		{printf("Exp -> Exp and Exp\n"); }
	|
		exp OR exp
		{printf("Exp -> Exp or Exp\n"); }
	|
		exp LT exp
		{printf("Exp -> Exp lt Exp\n"); }
	|
		exp LE exp
		{printf("Exp -> Exp le Exp\n"); }
	|
		exp EQ exp
		{printf("Exp -> Exp eq Exp\n"); }
	|
		ID LSP exp RSP
		{printf("Exp -> id lsp Exp rsp\n"); }
	|

		ID LP explist RP
		{printf("Exp -> id lp Exp rp\n"); }
	|
		LP exp RP
		{printf("Exp -> lp Exp rp\n"); }
	| 
		exp DOT exp
		{printf("Exp -> Exp dot Exp\n"); }
	|
		LIT
		{printf("Exp -> lit\n"); }
	|
		TRUE
		{printf("Exp -> true\n"); }
	|
		FALSE
		{printf("Exp -> false\n"); }
	|
		ID
		{printf("Exp -> id\n"); }
	|
		THIS
		{printf("Exp -> this\n"); }
	|	
		NEW INT LSP exp RSP
		{printf("Exp -> new int lsp Exp rsp\n"); }
	|
		NEW ID LP RP
		{printf ("Exp -> new id lp rp"); }
	|
		NOT exp
		{printf("Exp -> not Exp\n"); }
	;

explist	:	exp exprests
		{printf("ExpList -> Exp ExpRest*\n"); }
	|
		{printf("ExpList -> \n"); }
	;

exprests: 	exprest exprests
		{printf("ExpRest*) exprests: exprest exprests \n"); }
	| 
		{printf("ExpRest -> \n"); }
	;


exprest	: 	COMMA exp
		{printf("ExpRest -> comma Exp\n"); }
	;
		
// Practice on writing the grammar rules for
// 1. type
// 2. statement
// 3. exp
// 4. explist
// 5. exprest
// (see the description in Programming Assignment #1)

%%

int yyerror(char *s)
{
	printf("At line: %d %s\n",yylineno,s);
	return 1;
}
```

**Flex compilation**
To use **Flex** to translate *minij_lex.l* into *minij_lex.c*, run the command below.
```
flex -ominij_lex.c minij_lex.l
```

**Bison compilation**

To compile *minij_parse.y* into *minij_parse.c* using **Bison**, run the command below.
```
bison -d -o minij_parse.c minij_parse.y
```
The -d switch produces a header file *minij_parse.h*.

**gcc compilation**
to compile *minij_lex.c* into *minij_lex.o*, *minj_parse.c* into *minij_parse.o*, and *minij.c* into *minij.o*, run the commands below.
```
gcc -c minij_lex.c
gcc -c minij_parse.c
gcc -c minij.c
```

**Building executable**
Use gcc to link *minij.o*, *minij_lex.o*, and *minij_parse.o* into *mjparse.exe* using the command below.
```
gcc -o mjparse.exe minij.o minij_lex.o minij_parse.o
```

**3. Execution and Output**

To run your parser:
```
./mjparse test1.mj 
./mjparse test2.mj 
./mjparse test3.mj
```
### Test run results

Test 1
![](https://i.imgur.com/Ei3VB08.png)


Test 2
![](https://i.imgur.com/qlgOsM7.png)


Test 3
![](https://i.imgur.com/AfidH0Q.png)


