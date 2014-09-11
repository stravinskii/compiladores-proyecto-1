%{
#include <iostream>
#include "../lib/Stack.h"

int newLine=1;
int indenting=0;
int indentLevel=0;
int nivel=0;
Stack stack;

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

/*Administrativos*/
INDENT		("        "|"\t")
DEDENT		"dedent"
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
{ERROR}		{std::cout <<"Error de sintáxis en la línea " << newLine; yyterminate();}
{COMMENT}	/* we do nothing as expected */
{NEWLINE}	{std::cout << std::endl; newLine++;/*std::cout<<newLine;*/}
{ID}		std::cout << "ID";
{STRING}	{char in = yyinput();
		while(in != '"' ){
			in=yyinput();
			newLine= in=='\n'? newLine++:newLine;
		}
		if (in == '\0'){
			std::cout<<"Error de sintaxis en la línea "<<newLine <<": String no terminada correctamente";
			yyterminate();
		}else
			unput(in);}
{INDENT}	{indenting= indenting || yytext=="\n"? 1: 0;
		while(indenting){
			yylex();
			nivel++;
			printf("nivel: %i\n",nivel);
		}
		if(nivel==indentLevel+1){
			stack.push(++indentLevel);
			std::cout<<"Indenting value is: "<<indenting <<"INDENT token produced";
		}else if(nivel==indentLevel-1){
			stack.pop();
			indentLevel--;
			std::cout<<"Indenting value is: "<<indenting <<"DEDENT token produced";
		}else{
			std::cout<<"Indentation error in line: "<<newLine;
			yyterminate();
		}
		nivel=0;
		unput(*yytext);}
{DEDENT}	{stack.pop();--indenting;std::cout<<"Indenting value is: "<<indenting <<"DEDENT token produced";}


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
