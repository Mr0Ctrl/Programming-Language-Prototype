%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
 
#include "system.h" 

void yyerror(char *);
int yylex(void);

extern int line_number; // lex dosyasında tanımlanan satır numarasını çağır

%}

%union {
    int     ival;
    float   fval;
    char    cval;
    bool    bval;
    char*   sval;
    Data    data;
}

%token <ival> INTEGER
%token <fval> FLOAT
%token <data> IDENTIFIER

%token ASSIGN
%token NLINE TAB
%token LOOP
%token BREAK
%token IF

%left '=' '<' '>'
%left '+' '-'
%left '*' '/'

%nonassoc UMINUS

%type <data> numeric expr statement
%type <data> math_op compare_op logic_op

%type <data> assignment condition loop BREAK NLINE IF LOOP

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
    | statement ';' {
        if($1.type == tBool ){printf("%s\n", $1.value.bval ? "true" : "false");}
        if($1.type == tInt  ){printf("%d\n", $1.value.ival);}
        if($1.type == tFloat){printf("%f\n", $1.value.fval);}
        if($1.type == tChar ){printf("%c\n", $1.value.cval);}
    }
    | assignment
    | condition
    | loop
    | BREAK
    | expr
    ;

assignment : 
    IDENTIFIER ASSIGN expr
    ;

condition:
    IF '('expr')' NLINE statement_list ':'
    ;

loop:
    LOOP NLINE statement_list ':'
    | LOOP '('expr')' NLINE statement_list ':'
    ;


expr : 
    numeric
    | math_op
    | compare_op
    | logic_op
    | IDENTIFIER
    ;

math_op:
    expr '+' expr
    | expr '-' expr
    | expr '*' expr
    | expr '/' expr
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
    INTEGER {
        $$.type = tInt;
        $$.value.ival = $1;
    }
    | FLOAT
    {
        $$.type = tFloat;
        $$.value.fval = $1;
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