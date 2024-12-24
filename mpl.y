%{

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

void yyerror(char *);
int yylex(void);

#include "base.h"

struct SymbolTable symbolTable[100];
int symbolTableIndex = 0;
extern int line_number;


%}

%union {
    int     ival;
    float   fval;
    char    cval;
    bool    bval;
    char*   sval;
    struct Data* dataE;
}

%token <ival> INTEGER
%token <fval> FLOAT
%token <sval> IDENTIFIER

%token ASSIGN
%token NLINE TAB
%token LOOP
%token BREAK
%token IF

%left '=' '<' '>'
%left '+' '-'
%left '*' '/'

%nonassoc UMINUS

%type <dataE> numeric expr statement
%type <dataE> math_op compare_op logic_op

%type <dataE> assignment condition loop BREAK NLINE IF LOOP

%%

program :
    statement_list
    ;

statement_list:
    statement NLINE
    | statement_list statement
    ;

statement :
    NLINE
    | statement ';' 
        {
        if($1->type == tBool ){printf("%s\n", $1->value.bval ? "true" : "false");}
        if($1->type == tInt  ){printf("%d\n", $1->value.ival);}
        if($1->type == tFloat){printf("%f\n", $1->value.fval);}
        if($1->type == tChar ){printf("%c\n", $1->value.cval);}
        }
    | assignment
    | condition
    | loop
    | BREAK
    | expr
    ;

assignment : 
    IDENTIFIER ASSIGN expr
    {
        int symbolIndex = addSymbol($1, (int)$3->type);
        symbolTable[symbolIndex].data->value = $3->value;
        free($3);
        $$ = symbolTable[symbolIndex].data;
    }
    ;

condition:
    IF '('expr')' NLINE statement_list ':' 
    {
        $$ = malloc(sizeof(struct Data));
        $$->type = tBool;

        if($3->type == tInt)
        {
            $$->value.bval = ($3->value.ival != 0);
        }
        if($3->type == tFloat)
        {
            $$->value.bval = ($3->value.fval != 0.0);
        }
        
        if($$->value.bval)
        {
            printf("??\n");
        }
    }
    ;

loop:
    LOOP NLINE statement_list ':'
    | LOOP '('expr')' NLINE statement_list ':'
    ;


expr : 
    numeric         //{$$ = $1;}
    | math_op       //{$$ = $1;}
    | compare_op    
    | logic_op      
    | IDENTIFIER    
    {
        $$ = malloc(sizeof(struct Data));
        int i =findSymbol($1);
        if(i == -1){yyerror("tanınmayan ifade");}
        $$->type = symbolTable[i].data->type;
        $$->value = symbolTable[i].data->value;
    }  
    ;

math_op:
    expr '+' expr   {$$ = basicMOp('+',$1 ,$3);}
    | expr '-' expr {$$ = basicMOp('-',$1 ,$3);}
    | expr '*' expr {$$ = basicMOp('*',$1 ,$3);}
    | expr '/' expr {$$ = basicMOp('/',$1 ,$3);}
    ;
compare_op:
    expr '<' expr
    | expr '>' expr
    | expr '=' expr
    ;
logic_op:
    expr '|' expr
    | expr '&' expr
    ;

numeric:
    INTEGER 
    {   
        $$ = malloc(sizeof(struct Data));
        $$->type = tInt;
        $$->value.ival = $1;
    }
    | FLOAT
    {
        $$ = malloc(sizeof(struct Data));
        $$->type = tFloat;
        $$->value.fval = $1;
    }
    ;
    

%%

void yyerror(char *s) {
    fprintf(stderr, "Satır %d: Syntax hatası: %s\n", line_number, s);
    return;
}

int main(void) {
    yyparse();
    return 0;
}