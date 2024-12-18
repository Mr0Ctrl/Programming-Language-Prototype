%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "mpl.tab.h"
int line_number = 1; // Satır sayacı
%}

%%

"i"[A-Z][a-zA-Z]*          {
        yylval.svalue = strdup(yytext+1); 
        return INT_VAR;
}

"f"[A-Z][a-zA-Z]*          {
        yylval.svalue = strdup(yytext+1); 
        return FLOAT_VAR;
}

"s"[A-Z][a-zA-Z]*          {
        yylval.svalue = strdup(yytext+1); 
        return STR_VAR;
}

0|([1-9][0-9]*)         {
        yylval.ivalue = atoi(yytext);
        return INTEGER;
    }

(0|([1-9][0-9]*))?\.[0-9]+  {
        yylval.fval = atof(yytext);
        return FLOAT;
    }
\"[^\n"]*\"                 {
        yylval.sval = strndup(yytext + 1, yyleng - 2);
        if (yylval.sval == NULL) {
            fprintf(stderr, "Bellek hatası!\n");
            exit(1);
        }
        return STRING;    
}

[+-*/()=<>&|!;]  {return *yytext;}

":="            { return ASSIGN; }

"yine"          { return LOOP; }
"kop"           { return BREAK; }
"ise"           { return IF; }

\n              { line_number++; return NLINE; }  // Yeni komut satırı
[ \t]+          ; // Boşlukları yoksay
.               { printf("Tanınmayan karakter: %s, Satır: %d\n", yytext, line_number); }

%%

int yywrap(void) {
    return 1;
}
