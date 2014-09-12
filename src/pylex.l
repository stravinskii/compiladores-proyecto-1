%{
#include <iostream>
#include "../lib/Stack.h"

int newLine=1;
Stack stack;

%}

%option noyywrap
%option outfile="pylex.cpp"


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
EQUALS		"=="
ASSIGN		"="
PLUS		"+"
MINUS		"-"
MULT		"*"
DIV		"/"
MOD		"%"

/*Administrativos y caracteres especiales*/

INDENT		"        "|"\t"
DEDENT		"dedent"
SALIR		"salir"
ID		[a-z][a-z0-9]*
NUMBER		[0-9]*
FRACTION	[0-9]*.[0-9]*
NEWLINE		"\n"+
COMMENT		"#"
STRING		"\""
COMMA		","
ERROR		"mistake"
EOF		"\0"


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
{EQUALS}	std::cout << "EQUALS";
{ASSIGN}	std::cout << "ASSIGN";
{NUMBER}	std::cout << "NUMBER";

{COMMA}		std::cout<<" ,";
{PLUS}		std::cout<<" +";
{MINUS}		std::cout<<" -";
{MULT}		std::cout<<" *";
{DIV}		std::cout<<" /";
{MOD}		std::cout<<" %";

{SALIR}		yyterminate();
{ERROR}		{std::cout<<"Error de sintáxis en la línea " <<newLine; yyterminate();}
{COMMENT}	{int in=yyinput();
		while(in != '\n'){
			in=yyinput();
		}
		std::cout <<"COMMENT NEWLINE\n";newLine++;}
{NEWLINE}	{std::cout <<" NEWLINE\n"; newLine++;
		int in =yyinput(); 
		if(in!='\t' && in!=' ' && in !='#'){
			while(stack.get_Size()){
				stack.pop();
				std::cout<<"DEDENT ";
			}
		}
		unput(in);
		}		
{ID}		std::cout <<"ID";
{STRING}	{int in = yyinput();
		while(in != '"' && in != '\n' ){
			in=yyinput();
		}
		unput(' ');
		if (in == '\n' || in==EOF){
			std::cout<<"Error de sintaxis en la línea "<<newLine <<": String no terminada correctamente\n";
			yyterminate();
		}else{
		std::cout<<"STRING";}}
{INDENT}	{int in=yyinput(); int spaces=0;int indentLevel= stack.pick(); int nivel=1;
		while(in==' '||in=='\t'){
			if(in==' ')
				spaces++;
			in=yyinput();
			if(spaces==8){
				++spaces;
				spaces=0;
				++nivel;
				std::cout<<"INDENT ";
			}
			++nivel;
		}
		unput(in);
		
		if(nivel==indentLevel+1 ){
			stack.push(++indentLevel);
			std::cout<<"INDENT ";
		}else if(nivel==indentLevel-1){
			stack.pop();
			indentLevel--;
			std::cout<<"DEDENT ";
		}else if(nivel!=indentLevel){
			std::cout<<"Indentation error in line: "<<newLine;
			yyterminate();
		}
		nivel=0;}
{EOF}		std::cout<<"EOF";


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
