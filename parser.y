%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s);

FILE *outfile;

int temp_count = 0;

char *newtemp()
{
    char temp[20];

    sprintf(temp, "t%d", ++temp_count);

    return strdup(temp);
}
%}

%union
{
    char *str;
}

%token BCSMAIN
%token IF ELSE WHILE
%token INT BOOL
%token LE GE EQ NE LT GT
%token PLUS MULT ASSIGN
%token PUNCT
%token LBRACE RBRACE LPAREN RPAREN

%token <str> NUM ID

%type <str> type
%type <str> expr
%type <str> aexpr
%type <str> term
%type <str> factor

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
      {
          $$ = strdup("int");
      }
    | BOOL
      {
          $$ = strdup("bool");
      }
    ;

stmtlist:
      stmtlist PUNCT stmt
    | stmt
    ;

stmt:
      ID ASSIGN aexpr
      {
          fprintf(outfile, "%s = %s\n", $1, $3);
      }

    | IF LPAREN expr RPAREN LBRACE stmtlist RBRACE
      ELSE LBRACE stmtlist RBRACE

    | WHILE LPAREN expr RPAREN LBRACE stmtlist RBRACE
    ;

expr:
      aexpr relop aexpr
      {
          $$ = $1;
      }
    | aexpr
      {
          $$ = $1;
      }
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
      {
          char *temp = newtemp();

          fprintf(outfile, "%s = %s + %s\n",
                  temp, $1, $3);

          $$ = temp;
      }
    | term
      {
          $$ = $1;
      }
    ;

term:
      term MULT factor
      {
          char *temp = newtemp();

          fprintf(outfile, "%s = %s * %s\n",
                  temp, $1, $3);

          $$ = temp;
      }
    | factor
      {
          $$ = $1;
      }
    ;

factor:
      ID
      {
          $$ = $1;
      }
    | NUM
      {
          $$ = $1;
      } ;
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

    outfile = fopen("output.txt", "w");

    if (!outfile) {
        printf("Error creating output file");
        fclose(file);
        return 1;
    }

    yyin = file;

    int result = yyparse();

    fclose(file);
    fclose(outfile);

    if (result == 0)
        printf("Parsing Successful\n");
    else
        remove("output.txt");

    return result;
}
