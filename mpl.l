%{
#include <string.h>
#include "mpl.tab.h"
void yyerror(char *);
#include <stdlib.h>
int line_number = 1; // Satır sayacını ekledik
%}


%%

":="            { return ASSIGN; }
"yine"          { return LOOP; }
"kop"           { return BREAK; }
"ise"           { return IF; }

[a-z][a-zA-Z1-9]*          {
        yylval.sval = strdup(yytext); 
        return IDENTIFIER;
}

0|([1-9][0-9]*)         {
        yylval.ival = atoi(yytext);
        return INTEGER;
    }

(0|([1-9][0-9]*))?\.[0-9]+  {
        yylval.fval = atof(yytext);
        return FLOAT;
    }

[-+*/()=<>&|!;:]  {return *yytext;}

\n              { line_number++; return NLINE; }
"//".*          ; // Boş işlem (yorumları yoksay)
[ \t]+          ; // Boşlukları yoksay
.               { yyerror("Unknown character");}

%%

int yywrap(void) {
    return 1;
}