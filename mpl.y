%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(char *);
int yylex(void);

extern int line_number; // lex dosyasında tanımlanan satır numarasını çağır
%}

%union {
    int ival;
    float fval;
    char* sval;
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
    | IDENTIFIER
    | expr '+' expr
    | expr '-' expr
    | expr '*' expr
    | expr '/' expr
    | expr '<' expr
    | expr '>' expr
    | expr '=' expr
    ;

numeric:
    INTEGER
    | FLOAT

%%

void yyerror(char *s) {
    fprintf(stderr, "Satır %d: Syntax hatası: %s\n", line_number, s);
    return;
}

int main(void) {
    yyparse();
    return 0;
}