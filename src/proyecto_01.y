%{
#include <stdio.h>
int yylex();
int yyerror(const char *s)	{ printf("Error %s\n",s);};
int seguir=1;
%}

%token SALIDA
%%
s:	SALIDA		{seguir=0;};
%%


