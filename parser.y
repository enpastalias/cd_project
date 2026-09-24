%{
#include <stdio.h>

int yylex(void);
void yyerror(const char *s);
%}

%token BCSMAIN
%token IF ELSE WHILE
%token INT BOOL
%token LE GE EQ NE LT GT
%token NUM ID
%token PLUS MULT ASSIGN
%token PUNCT
%token LBRACE RBRACE LPAREN RPAREN

%%

program:
      BCSMAIN LBRACE declist stmtlist RBRACE
    ;

declist:
      declist decl
    | decl
    ;

decl:
      type ID PUNCT
    ;

type:
      INT
    | BOOL
    ;

stmtlist:
      stmtlist PUNCT stmt
    | stmt
    ;

stmt:
      ID ASSIGN aexpr
    | IF LPAREN expr RPAREN LBRACE stmtlist RBRACE
      ELSE LBRACE stmtlist RBRACE
    | WHILE LPAREN expr RPAREN LBRACE stmtlist RBRACE
    ;

expr:
      aexpr relop aexpr
    | aexpr
    ;

relop:
      LE
    | GE
    | EQ
    | NE
    | LT
    | GT
    ;

aexpr:
      aexpr PLUS term
    | term
    ;

term:
      term MULT factor
    | factor
    ;

factor:
      ID
    | NUM
    ;

%%

void yyerror(const char *s)
{
    printf("Syntax Error\n");
}

extern FILE *yyin;

int main(int argc, char *argv[])
{
    if (argc != 2) {
        printf("Pass file name as argument");
        return 1;
    }

    FILE *file = fopen(argv[1], "r");

    if (!file) {
        printf("Error opening file");
        return 1;
    }

    yyin = file;

    int result = yyparse();

    fclose(file);

    if (result == 0)
        printf("Parsing Successful\n");

    return result;
}
