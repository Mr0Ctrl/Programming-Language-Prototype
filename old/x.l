%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "mpl.tab.h"
int line_number = 1; // Satır sayacı
%}

DIGIT   [0-9]
LOWER   [a-z]
UPPER   [A-Z]

LETTER  {LOWER}|{UPPER}
INT_VAR "t"{UPPER}({LETTER}|{DIGIT})*

%%

{DIGIT}+        {
        yylval.ivalue = atoi(yytext);
        return INTEGER;
    }

{INT_VAR}   {
        yylval.svalue = strdup(yytext);
        return INT_VARIABLE;
    }

"+"             { return ADD; }
"-"             { return SUB; }
"*"             { return MUL; }
"/"             { return DIV; }

"("             { return LPAREN; }
")"             { return RPAREN; }

":="            { return ASSIGN; }

"yine"          { return LOOP; }
"kop"           { return BREAK; }
"ise"           { return IF; }

"="             { return EQUAL; }
">"             { return GREAT; }

"&"             { return AND; }
"|"             { return OR; }
"!"             { return NOT; }

";"             { return SEMICOLON; } // Satır sonunda işlem çıktısı için
\n              { line_number++; return NLINE; }  // Yeni komut satırı
[ \t]+          ; // Boşlukları yoksay
.               { printf("Tanınmayan karakter: %s, Satır: %d\n", yytext, line_number); }

%%

int yywrap(void) {
    return 1;
}
