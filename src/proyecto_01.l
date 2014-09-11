%{
#include <iostream>
#include "../lib/Stack.h"

int newLine=1;

%}

%option noyywrap
%option outfile="proyecto_01_scanner.cpp"


FALSE		"False"
CLASS		"class"
FINALLY		"finally"
IS		"is"
RETURN		"return"
NONE		"None"
CONTINUE	"continue"
FOR		"for"
LAMBDA		"lambda"
TRY		"try"
TRUE		"True"
DEF		"def"
FROM		"from"
WHILE		"while"
AND		"and"
DEL		"del"
NOT		"not"
WITH		"with"
AS		"as"
ELIF		"elif"
IF		"if"
OR		"or"
ELSE		"else"
IMPORT		"import"
PASS		"pass"
BREAK		"break"
EXCEPT		"except"
IN		"in"
PRINT		"print"

SALIR		"salir"
ID 		[a-z][a-z0-9]*
NUMBER		[0-9]*
FRACTION	[0-9]*.[0-9]*
NEWLINE		[\n]
COMMENT		"#"
STRING		"\""
ERROR		"mistake"
EOF		[\0]


%%

{FALSE}		std::cout << "FALSE";                     
{CLASS}		std::cout << "CLASS";                     
{FINALLY}	std::cout << "FINALLY";               
{IS}		std::cout << "IS";                     	
{RETURN}	std::cout << "RETURN";
{NONE}		std::cout << "NONE";
{CONTINUE}	std::cout << "CONTINUE";
{FOR}		std::cout << "FOR";
{LAMBDA}	std::cout << "LAMBDA";
{TRY}		std::cout << "TRY";
{TRUE}		std::cout << "TRUE";
{DEF}		std::cout << "DEF";
{FROM}		std::cout << "FROM";
{WHILE}		std::cout << "WHILE";
{AND}		std::cout << "AND";
{DEL}		std::cout << "DEL";
{NOT}		std::cout << "NOT";
{WITH}		std::cout << "WITH";
{AS}		std::cout << "AS";
{ELIF}		std::cout << "ELIF";
{IF}		std::cout << "IF";
{OR}		std::cout << "OR";
{ELSE}		std::cout << "ELSE";
{IMPORT}	std::cout << "IMPORT";
{PASS}		std::cout << "PASS";
{BREAK}		std::cout << "BREAK";
{EXCEPT}	std::cout << "EXCEPT";
{IN}		std::cout << "IN";
{PRINT}		std::cout << "PRINT";

{NUMBER} 	std::cout << "NUMBER";

{SALIR}		yyterminate();
{ERROR}		{std::cout <<"Error de sintáxis en la línea " << newLine<<"\n"; yyterminate();}
{COMMENT}	/* we do nothing as expected */
{NEWLINE}	{std::cout << std::endl; newLine++;}
{ID}		std::cout << "ID";
{STRING}	{int in = yyinput();
	while(in != '"' ){
		in=yyinput();
		newLine= in=='\n'? newLine++:newLine;
	}
	if (in == '\0'){
		std::cout<<"Error de sintaxis en la línea "<<newLine <<": String no terminada correctamente";
		yyterminate();
	}}



%%



int main(int argc, char *argv[])
{
	Stack stack;
	// push zero to stack as proposed in Python documentation
	stack.push(0);

	if (argc > 1)
	{
		yyin = fopen(argv[1], "r");
	} 
	else
	{
		yyin = stdin;
	}

	yylex();
}
