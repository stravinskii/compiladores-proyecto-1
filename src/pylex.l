%{
#include <iostream>
#include "../lib/Stack.h"
#include <fstream>

using namespace std;
int newLine=1;
Stack stack;
ofstream arch_salida;



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

{FALSE}		cout << "FALSE";arch_salida<<"FALSE";
{CLASS}		cout << "CLASS";arch_salida<<"CLASS";
{FINALLY}	cout << "FINALLY";arch_salida<<"FINALLY";
{IS}		cout << "IS";arch_salida<<"IS";
{RETURN}	cout << "RETURN";arch_salida<<"RETURN";
{NONE}		cout << "NONE";arch_salida<<"NONE";
{CONTINUE}	cout << "CONTINUE";arch_salida<<"CONTINUE";
{FOR}		cout << "FOR";arch_salida<<"FOR";
{LAMBDA}	cout << "LAMBDA";arch_salida<<"LAMBDA";
{TRY}		cout << "TRY";arch_salida<<"TRY";
{TRUE}		cout << "TRUE";arch_salida<<"TRUE";
{DEF}		cout << "DEF";arch_salida<<"DEF";
{FROM}		cout << "FROM";arch_salida<<"FROM";
{WHILE}		cout << "WHILE";arch_salida<<"WHILE";
{AND}		cout << "AND";arch_salida<<"AND";
{DEL}		cout << "DEL";arch_salida<<"DEL";
{NOT}		cout << "NOT";arch_salida<<"NOT";
{WITH}		cout << "WITH";arch_salida<<"WITH";
{AS}		cout << "AS";arch_salida<<"AS";
{ELIF}		cout << "ELIF";arch_salida<<"ELIF";
{IF}		cout << "IF";arch_salida<<"IF";
{OR}		cout << "OR";arch_salida<<"OR";
{ELSE}		cout << "ELSE";arch_salida<<"ELSE";
{IMPORT}	cout << "IMPORT";arch_salida<<"IMPORT";
{PASS}		cout << "PASS";arch_salida<<"PASS";
{BREAK}		cout << "BREAK";arch_salida<<"BREAK";
{EXCEPT}	cout << "EXCEPT";arch_salida<<"EXCEPT";
{IN}		cout << "IN";arch_salida<<"IN";
{PRINT}		cout << "PRINT";arch_salida<<"PRINT";
{EQUALS}	cout << "EQUALS";arch_salida<<"EQUALS";
{ASSIGN}	cout << "ASSIGN";arch_salida<<"ASSIGN";
{NUMBER}	cout << "NUMBER";arch_salida<<"NUMBER";

{COMMA}		cout<<" ,";arch_salida<<" ,";
{PLUS}		cout<<" +";arch_salida<<" +";
{MINUS}		cout<<" -";arch_salida<<" -";
{MULT}		cout<<" *";arch_salida<<" *";
{DIV}		cout<<" /";arch_salida<<" /";
{MOD}		cout<<" %";arch_salida<<" %";


{ERROR}		{cout<<"Error de sintáxis en la línea " <<newLine; yyterminate();}
{COMMENT}	{int in=yyinput();
		while(in != '\n'){
			in=yyinput();
		}
		arch_salida<<"COMMENT NEWLINE\n";
		cout <<"COMMENT NEWLINE\n";newLine++;}
{NEWLINE}	{arch_salida<<" NEWLINE\n";
		cout <<" NEWLINE\n"; newLine++;
		int in =yyinput(); 
		if(in!='\t' && in!=' ' && in !='#'){
			while(stack.get_Size()){
				stack.pop();
				arch_salida<<"DEDENT ";
				cout<<"DEDENT ";
			}
		}
		unput(in);
		}		
{ID}		cout <<"ID";arch_salida<<"ID";
{STRING}	{int in = yyinput();
		while(in != '"' && in != '\n' ){
			in=yyinput();
		}
		unput(' ');
		if (in == '\n' || in==EOF){
			cout<<"Error de sintaxis en la línea "<<newLine <<": String no terminada correctamente\n";
			yyterminate();
		}else{
		arch_salida<<"STRING";
		cout<<"STRING";}}
{INDENT}	{int in=yyinput(); int spaces=0;int indentLevel= stack.pick(); int nivel=1;
		while(in==' '||in=='\t'){
			if(in==' ')
				spaces++;
			in=yyinput();
			if(spaces==8){
				++spaces;
				spaces=0;
				++nivel;
				arch_salida<<"INDENT ";
				cout<<"INDENT ";
			}
			++nivel;
		}
		unput(in);
		
		if(nivel>indentLevel&& in != '#'){
			stack.push(nivel);
			indentLevel++;
			arch_salida<<"INDENT ";
			cout<<"INDENT ";
		}else if(nivel<indentLevel && in != '#'){
			stack.pop();
			indentLevel--;
			arch_salida<<"DEDENT ";
			cout<<"DEDENT ";
		}else if(nivel!=indentLevel && in != '#'){
			cout<<"Error de indentación en la línea: "<<newLine;
			yyterminate();
		}
		nivel=0;}
{EOF}		cout<<"EOF";arch_salida<<"EOF";


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
	arch_salida.open("writer.txt");
	yylex();
	arch_salida.close();

	
}
