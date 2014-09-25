%{
#include <iostream>
#include "../lib/Stack.h"
#include <fstream>

using namespace std;
int newLine=1;
stack stack;
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
OPERATORS			("+"|"-"|"*"|"**"|"/"|"//"|"%"|"<<"|">>"|"&"|"|"|"^"|"~"|"<"|">"|"<="|">="|"=="|"!=")
DELIMITERS			("("|")"|"["|"]"|"{"|"}"|","|":"|"."|";"|"@"|"="|"->"|"+="|"-="|"*="|"/="|"//="|"%="|"&="|"|="|"^="|">>="|"<<="|"**=")


/*Administrativos, tipos y caracteres especiales*/
DOTS		":"



ID 			[a-zA-z][_a-zA-Z0-9]*
NUMBER			{INTEGER}|{FLOATNUMBER}
INTEGER        		{DECIMALINTEGER}
DECIMALINTEGER		{NONZERODIGIT}{DIGIT}*|"0"+
NONZERODIGIT  		[1-9]
DIGIT			[0-9]
FLOATNUMBER  		{POINTFLOAT}|{EXPONENTFLOAT}
POINTFLOAT   		{INTPART}?{FRACTION}|{INTPART}"."
EXPONENTFLOAT		({INTPART}|{POINTFLOAT}){EXPONENT}
INTPART      		{DIGIT}+
FRACTION     		"."{DIGIT}+
EXPONENT     		("e"|"E")("+"|"-"){1}{DIGIT}+

NEWLINE		"\n"
COMMENT		"#"
STRING		"\""
COMMA		","
EOF		"\0"


%%

{FALSE}		arch_salida<<"FALSE ";
{CLASS}		arch_salida<<"CLASS ";
{FINALLY}	arch_salida<<"FINALLY ";
{IS}		arch_salida<<"IS ";
{RETURN}	arch_salida<<"RETURN ";
{NONE}		arch_salida<<"NONE ";
{CONTINUE}	arch_salida<<"CONTINUE ";
{FOR}		arch_salida<<"FOR ";
{LAMBDA}	arch_salida<<"LAMBDA ";
{TRY}		arch_salida<<"TRY ";
{TRUE}		arch_salida<<"TRUE ";
{DEF}		arch_salida<<"DEF ";
{FROM}		arch_salida<<"FROM ";
{WHILE}		arch_salida<<"WHILE ";
{AND}		arch_salida<<"AND ";
{DEL}		arch_salida<<"DEL ";
{NOT}		arch_salida<<"NOT ";
{WITH}		arch_salida<<"WITH ";
{AS}		arch_salida<<"AS ";
{ELIF}		arch_salida<<"ELIF ";
{IF}		arch_salida<<"IF ";
{OR}		arch_salida<<"OR ";
{ELSE}		arch_salida<<"ELSE ";
{IMPORT}	arch_salida<<"IMPORT ";
{PASS}		arch_salida<<"PASS ";
{BREAK}		arch_salida<<"BREAK ";
{EXCEPT}	arch_salida<<"EXCEPT ";
{IN}		arch_salida<<"IN ";
{PRINT}		arch_salida<<"PRINT ";
{NUMBER}	arch_salida<<"NUMBER ";


{OPERATORS}	arch_salida<<yytext;
{DELIMITERS} 	arch_salida<<yytext;


{COMMENT}	{int in=yyinput();
		while(in != '\n'){
			in=yyinput();
		}
		unput(in);
		}
{NEWLINE}	{
		arch_salida<<"NEWLINE\n";
		newLine++;
		int in =yyinput();
		while(in=='\n'){
			newLine++;
			in =yyinput();
		}
		if(in!='\t' && in!=' ' && in !='#'){
			while(stack.peek()!=0){
				stack.pop();
				arch_salida<<"DEDENT ";
			}
		}else if(in =='\t'|| in==' '){
			int indentLevel= stack.peek();
			int spaces= 0;
			/*arch_salida<<in<<"<--IN";
			arch_salida<<spaces<<"<--SPACES";*/
			while(in==' '||in=='\t'){
				if(in==' ')
					spaces++;
				if(in=='\t')
					spaces+=8;
				in=yyinput();
			}
			/*arch_salida<<spaces<<"<--SPACES";*/
			if(spaces>indentLevel && in !='#'){
				stack.push(spaces);
				arch_salida<<"INDENT ";
			}else if(spaces<indentLevel && in !='#'){
				stack.pop();
				if (spaces== stack.peek())
					arch_salida<<"DEDENT ";	
				else{
					cout<<"Error de indentación en la línea: "<<newLine;
					yyterminate();
				}

			}
		}
		unput(in);
		}
		
{ID}		arch_salida<<"ID ";
{STRING}	{int in = yyinput();
		while(in != '"' && in != '\n'){
			in=yyinput();
		}
		if (in == '\n' || in==EOF){
			cout<<"Error de sintaxis en la línea "<<newLine <<": String no terminada correctamente\n";
			yyterminate();
		}else{
		arch_salida<<"STRING ";
		}}


{EOF}		arch_salida<<"EOF";


%%



int main(int argc, char *argv[])
{
	
	stack.push(0);
	if (argc > 1)
	{
		yyin = fopen(argv[1], "r");
		
	} 
	else
	{
		yyin = stdin;
	}
	arch_salida.open("ejemplo.pyl");
	yylex();
	cout<<'\n';
	arch_salida.close();
	

	
}
