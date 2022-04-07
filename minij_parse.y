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

