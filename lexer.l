%{
    #include "parser.tab.h"
%}

%%

"BcsMain"  {return BCSMAIN;}
"if"  {return IF;}
"else" {return ELSE;}
"while" {return WHILE;}
"int"    {return INT;}
"bool" {return BOOL;}

"<=" {return LE;}
">=" {return GE;}
"=="  {return EQ;}
"!="  {return NE;}
"<"  {return LT;}
">"  {return GT;}

[0-9]+  {return NUM;}

[a-zA-Z][a-zA-Z0-9]*  {return ID;}

"+" {return PLUS;}
"*" {return MULT;}
"=" {return ASSIGN;}
";"  {return PUNCT;}
"{"  {return LBRACE;}
"}"  {return RBRACE;}
"("  {return LPAREN;}
")"  {return RPAREN;}


[ \t\n]+   { /* ignore whitespace */ }

%%

int yywrap() {
    return 1;
}
