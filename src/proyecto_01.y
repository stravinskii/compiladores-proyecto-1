%{
#include <stdio.h>
int yylex();
int yyerror(const char *s)	{ printf("Error %s\n",s);}
}%

%%token 



int main() {
  
  printf(">> ");
        yyparse();

	return 0;
}
