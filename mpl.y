%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(char *);
int yylex(void); 
%}

%union {
    int ival;
    float fval;
    char* sval;
}

%token <ival> INTEGER
%token <fval> FLOAT
%token <sval> STRING
%token <sval> IDENTIFIER
%token ASSIGN
%token NLINE
%token LOOP
%token BREAK
%token IF

%left '=' '<' '>'
%left '+' '-'
%left '*' '/'

%nonassoc UMINUS

%%

program :
    statement_list
    ;

statement_list:
    statement
    | statement_list statement
    ;

statement : 
    statement NLINE
    | expr
    | assignment
    ;

expr : 
    INTEGER
    | IDENTIFIER
    | expr '+' expr
    | expr '-' expr
    | expr '*' expr
    | expr '/' expr
    | expr '<' expr
    | expr '>' expr
    | expr '=' expr
    | '('expr')'
    ;

assignment : 
    IDENTIFIER ASSIGN expr
    ;




%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
    return;
}

int main(void) {
    yyparse();
    return 0;
}
