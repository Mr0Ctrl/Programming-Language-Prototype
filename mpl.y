%{
%}

%token <ivalue> INTEGER
%token <fval> FLOAT

%token <sval> STRING

%token <svalue> INT_VAR
%token <svalue> FLOAT_VAR

%token <svalue> STR_VAR

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

program:
    lines
    ;

lines:
    line
    | lines line
    ;

line:
    
    ;
%%