%{
#include <iostream>
#include <string>
#include "My_Stack.h"


std::string s="";
//MY_Stack pila;
int nLine=0;

void newLine(){
	if(!nLine){
		{s.append("\n"); std::cout << s << std::endl;}
		nLine=0;
		}
	nLine=1;
}

%}

%option noyywrap
%option outfile="scanner.cpp"

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
NONLOCAL	"nonlocal"
WHILE		"while"
AND		"and"
DEL		"del"
GLOBAL		"global"
NOT		"not"
WITH		"with"
AS		"as"
ELIF		"elif"
IF		"if"
OR		"or"
YIELD		"yield"
ASSERT		"assert"
ELSE		"else"
IMPORT		"import"
PASS		"pass"
BREAK		"break"
EXCEPT		"except"
IN		"in"
RAISE		"raise"
TWODOTS		":"
NEWLINE		"\n"
USERNAME	"a-zA-Z"*


%%
"salir"		yyterminate();
{IF}		{s.append("IF"); std::cout << s << std::endl;}
{ELSE}		{s.append("ELSE"); std::cout << s << std::endl;}
{NEWLINE}	{newLine();}

%%



int main(int argc, char *argv[])
{
    yylex();
}














