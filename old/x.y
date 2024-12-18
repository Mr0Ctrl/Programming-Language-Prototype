%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    int yylex(void);
    void yyerror(char *s);

    struct SymbolTable {
        char *name;
        int value;
        char *type;
    };
    struct SymbolTable symbolTable[100];
    int symbolTableIndex = 0;
    extern int line_number;

    int findSymbol(char *name) {
        for(int i =0 ; i < symbolTableIndex; i++){
            if(strcmp(symbolTable[i].name, name) == 0){
                return i;
            }
        }
        return -1;
    }

    int addSymbol(char *name, char *type) {
        int existing = findSymbol(name);
        if(existing != -1) return existing;
        symbolTable[symbolTableIndex].name = strdup(name);
        symbolTable[symbolTableIndex].type = strdup(type);
        return symbolTableIndex++;
    }

%}

%union {
    int ivalue;
    char *svalue;
}

%token <ivalue> INTEGER
%token <svalue> INT_VARIABLE

%token ADD SUB MUL DIV  

%token LPAREN RPAREN

%token ASSIGN

%token NLINE SEMICOLON TAB

%token EQUAL GREAT 

%token NOT AND OR 

%token IF LOOP BREAK

%type <ivalue> factor
%type <ivalue> term
%type <ivalue> expr
%type <ivalue> statement

%left ADD SUB
%left MUL DIV
%left AND OR

%nonassoc EQUAL GREAT
%nonassoc NOT

%%

program:
    statement_list
    ;

statement_list:
    statement
    | statement_list statement
    ;

statement:
    statement NLINE
    | statement SEMICOLON { printf("%d\n", $1); }
    
    | INT_VARIABLE ASSIGN expression {
            int symbolIndex = addSymbol($1, "int");
            symbolTable[symbolIndex].value = $3;
    }
    ;
    
expr:
    term
    ;

term:
    factor
    ;

factor:
    INTEGER         { $$ = $1; }
    | INT_VARIABLE  {
            int symbolIndex = findSymbol($1);
            if(symbolIndex == -1){
                yyerror("Tanımsız değişken");
                $$ = 0;
            }else {
                    if(strcmp(symbolTable[symbolIndex].type, "int") == 0){
                        $$ = symbolTable[symbolIndex].value;
                    }else {
                        yyerror("geçersiz değişken tipi");
                        $$ = 0;
                    }
            }
        }





%%
void yyerror(char *s){
    fprintf(stderr, "Hata: %s, satır: %d\n", s, line_number);
}
int main(void) {
    yyparse();
    return 0;
}