%{
#include <iostream>
#include "../lib/Stack.h"
#include <string>

int newLine=1;
Stack stack;
std::string salida="";

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

{FALSE}		std::cout << "FALSE";salida.append("FALSE");
{CLASS}		std::cout << "CLASS";salida.append("CLASS");
{FINALLY}	std::cout << "FINALLY";salida.append("FINALLY");
{IS}		std::cout << "IS";salida.append("IS");
{RETURN}	std::cout << "RETURN";salida.append("RETURN");
{NONE}		std::cout << "NONE";salida.append("NONE");
{CONTINUE}	std::cout << "CONTINUE";salida.append("CONTINUE");
{FOR}		std::cout << "FOR";salida.append("FOR");
{LAMBDA}	std::cout << "LAMBDA";salida.append("LAMBDA");
{TRY}		std::cout << "TRY";salida.append("TRY");
{TRUE}		std::cout << "TRUE";salida.append("TRUE");
{DEF}		std::cout << "DEF";salida.append("DEF");
{FROM}		std::cout << "FROM";salida.append("FROM");
{WHILE}		std::cout << "WHILE";salida.append("WHILE");
{AND}		std::cout << "AND";salida.append("AND");
{DEL}		std::cout << "DEL";salida.append("DEL");
{NOT}		std::cout << "NOT";salida.append("NOT");
{WITH}		std::cout << "WITH";salida.append("WITH");
{AS}		std::cout << "AS";salida.append("AS");
{ELIF}		std::cout << "ELIF";salida.append("ELIF");
{IF}		std::cout << "IF";salida.append("IF");
{OR}		std::cout << "OR";salida.append("OR");
{ELSE}		std::cout << "ELSE";salida.append("ELSE");
{IMPORT}	std::cout << "IMPORT";salida.append("IMPORT");
{PASS}		std::cout << "PASS";salida.append("PASS");
{BREAK}		std::cout << "BREAK";salida.append("BREAK");
{EXCEPT}	std::cout << "EXCEPT";salida.append("EXCEPT");
{IN}		std::cout << "IN";salida.append("IN");
{PRINT}		std::cout << "PRINT";salida.append("PRINT");
{EQUALS}	std::cout << "EQUALS";salida.append("EQUALS");
{ASSIGN}	std::cout << "ASSIGN";salida.append("ASSIGN");
{NUMBER}	std::cout << "NUMBER";salida.append("NUMBER");

{COMMA}		std::cout<<" ,";salida.append(" ,");
{PLUS}		std::cout<<" +";salida.append(" +");
{MINUS}		std::cout<<" -";salida.append(" -");
{MULT}		std::cout<<" *";salida.append(" *");
{DIV}		std::cout<<" /";salida.append(" /");
{MOD}		std::cout<<" %";salida.append(" %");

{SALIR}		yyterminate();
{ERROR}		{std::cout<<"Error de sintáxis en la línea " <<newLine; yyterminate();}
{COMMENT}	{int in=yyinput();
		while(in != '\n'){
			in=yyinput();
		}
		salida.append("COMMENT NEWLINE\n");
		std::cout <<"COMMENT NEWLINE\n";newLine++;}
{NEWLINE}	{salida.append(" NEWLINE\n");
		std::cout <<" NEWLINE\n"; newLine++;
		int in =yyinput(); 
		if(in!='\t' && in!=' ' && in !='#'){
			while(stack.get_Size()){
				stack.pop();
				salida.append("DEDENT ");
				std::cout<<"DEDENT ";
			}
		}
		unput(in);
		}		
{ID}		std::cout <<"ID";salida.append("ID");
{STRING}	{int in = yyinput();
		while(in != '"' && in != '\n' ){
			in=yyinput();
		}
		unput(' ');
		if (in == '\n' || in==EOF){
			std::cout<<"Error de sintaxis en la línea "<<newLine <<": String no terminada correctamente\n";
			yyterminate();
		}else{
		salida.append("STRING");
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
				salida.append("INDENT ");
				std::cout<<"INDENT ";
			}
			++nivel;
		}
		unput(in);
		
		if(nivel>indentLevel&& in != '#'){
			stack.push(nivel);
			indentLevel++;
			salida.append("INDENT ");
			std::cout<<"INDENT ";
		}else if(nivel<indentLevel && in != '#'){
			stack.pop();
			indentLevel--;
			salida.append("DEDENT ");
			std::cout<<"DEDENT ";
		}else if(nivel!=indentLevel && in != '#'){
			std::cout<<"Error de indentación en la línea: "<<newLine;
			yyterminate();
		}
		nivel=0;}
{EOF}		std::cout<<"EOF";salida.append("EOF");


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
	std::cout <<salida;

	
}
