%{
#include <fstream>
#include <iostream>
#include "lib/stack.h"
stack stack;
// ofstream output;

int new_line = 1;
int newline_dedent = 0;

/*

TABNEWLINE			(("\t"|" ")+"\n")
<NEWLINE>{TABNEWLINE}	{
							std::cout<< "TABNEWLINE"<<std::endl;
							std::cout<< /"yytext  "<<yytext<<std::endl;
							new_line += yyleng / 2;
							std::cout<<"yyleng "<<yyleng<<std::endl;
							BEGIN(DEDENT);
							unput('\n');
						}

*/

%}

%option noyywrap
%option outfile="pylex.cpp"


NAME 				[a-zA-z][_a-zA-Z0-9]*
NUMBER				{INTEGER}|{FLOATNUMBER}
INTEGER        		{DECIMALINTEGER}
DECIMALINTEGER		{NONZERODIGIT}{DIGIT}*|"0"+
NONZERODIGIT  		[1-9]
DIGIT				[0-9]
FLOATNUMBER  		{POINTFLOAT}|{EXPONENTFLOAT}
POINTFLOAT   		{INTPART}+{FRACTION}|{INTPART}"."
EXPONENTFLOAT		({INTPART}|{POINTFLOAT}){EXPONENT}
INTPART      		{DIGIT}+
FRACTION     		"."{DIGIT}+
EXPONENT     		("e"|"E")("+"|"-"){1}{DIGIT}+

NEWLINE				"\n"+
COMMENT				"#"
STRING				"\""
INDENT				"\t"|" "
TABNEWLINE			(("\t"|" ")+"\n")

KEYWORDS			("False"|"class"|"finally"|"is"|"return"|"None"|"continue"|"for"|"lambda"|"try"|"True"|"def"|"from"|"while"|"and"|"del"|"not"|"with"|"as"|"elif"|"if"|"or"|"else"|"import"|"pass"|"break"|"except"|"in"|"print")
OPERATORS			("+"|"-"|"*"|"**"|"/"|"//"|"%"|"<<"|">>"|"&"|"|"|"^"|"~"|"<"|">"|"<="|">="|"=="|"!=")
DELIMITERS			("("|")"|"["|"]"|"{"|"}"|","|":"|"."|";"|"@"|"="|"->"|"+="|"-="|"*="|"/="|"//="|"%="|"&="|"|="|"^="|">>="|"<<="|"**=")

%s START
%s NEWLINE
%s DEDENT
%%

{KEYWORDS}		{
					// yylval.cadena = yytext;
					std::cout << yytext;
					BEGIN(INITIAL);
					// return KEYWORDS
				}
{OPERATORS}		{
					// yylval.cadena = yytext;
					std::cout << yytext;
					BEGIN(INITIAL);
					// return OPERATORS
				}
{DELIMITERS} 	{
					// yytext.cadena = yytext;
					std::cout << yytext;
					BEGIN(INITIAL);
					// return DELIMITERS
				}

{FLOATNUMBER}	{ 
					/* yylval.flotante = atof(yytext); */
					BEGIN(INITIAL);
					std::cout << "NUMBER";
				}
{INTEGER}		{ 
					/* yylval.entero = atoi(yytext); */
					BEGIN(INITIAL);
					std::cout << "NUMBER"; 
				}

{NAME}		{
				/* yylval.identificador = yytext; */
				BEGIN(INITIAL);
				std::cout << "NAME";
			}

{STRING}	{
				int in = yyinput();
				while (in != '"')
				{
					/* Python doesnt allow multi-line strings */
					in = yyinput();
					if (in == '\n' || in == EOF)
					{
						std::cout << "File \"" << yyin << "\", line " << new_line << std::endl;
						std::cout << "Syntax error: EOL while scanning a string" << std::endl;
						yyterminate();
					}
				}
				/* yylval.cadena = yytext; */
				std::cout << "STRING";
				BEGIN(INITIAL);
			}



<START>{NEWLINE}	{
						new_line++;
						int in = yyinput();
						if (in == '\n')
						{
							while (in != '\n')
							{
								new_line++;
								in = yyinput();
							}
						}

						if (in != '#')
						{
							BEGIN(INITIAL);
						}

						/* push back unmatching char */
						unput(in);
					}

<DEDENT>{NEWLINE}	{
						// std::cout<< std::endl << "dedent newline" << std::endl;
						char in = yyinput();
						/* if it's an indent */
						if (in == '\t' || in == ' ')
						{
							/* push back unmatching char */
							unput(in);
							BEGIN(NEWLINE);
							std::cout << " NEWLINE" << std::endl;
						}
						/* if it's a comment */
						else if (in == '#')
						{
							/* push back unmatching char */
							unput(in);
							BEGIN(NEWLINE);
							std::cout << " NEWLINE" << std::endl;
						}
						/* if it's not an INDENT or COMMENT check DEDENT */
						else
						{
							/* push back unmatching char */
							unput(in);

							/* if last DEDENT was returned */
							if (stack.peek() == 0)
							{
								if (!newline_dedent)
								{
									std::cout << " NEWLINE" << std::endl;
								}

								BEGIN(INITIAL);
								newline_dedent = 0;
							}
							/* there are still DEDENTS level to pop */
							else
							{
								if (!newline_dedent)
								{
									newline_dedent = 1;
									std::cout << "NEWLINE" << std::endl;
								}
								else
								{
									stack.pop();
									// yyless(yyleng);
									std::cout << "DEDENT ";
								}

								/* push back newline for next DEDENT */
								unput('\n');
							}
						}
					}

{NEWLINE}	{
				new_line++;
				int in = yyinput();
				if (in == '\n')
				{
					while (in != '\n')
					{
						new_line++;
						in = yyinput();
					}
				}

				/* push back unmatching char */
				unput(in);
				/* push back last newline for DEDENT check */
				BEGIN(DEDENT);
				// yyless(yyleng);
				unput('\n');
			}

<START>{COMMENT}	{
						int in = yyinput();
						while (in != '\n')
						{
							in = yyinput();
						}

						in = yyinput();
						if (in != '#' && in != '\n')
						{
							BEGIN(INITIAL);
						}

						/* push back unmatching char */
						unput(in);
					}

<NEWLINE>{COMMENT}	{
						int in = yyinput();
						while (in != '\n')
						{
							in = yyinput();
						}
						new_line++;

						/* check if there are more line comments */
						in = yyinput();
						if (in != '#')
						{
							BEGIN(INITIAL);
						}

						/* push back unmatching char */
						unput(in);
					}

{COMMENT}	{
				int in = yyinput();
				while(in != '\n')
				{
					in = yyinput();
				}
				unput(in);
				new_line++;
			}

<NEWLINE>{TABNEWLINE}	{
							new_line += yyleng / 2;
						}


<NEWLINE>{INDENT}	{
						int indent = 0;
						if (yytext == "\t")
						{
							indent = 8;
						}
						else
						{
							indent = 1;
						}

						int in = yyinput();
						while (in == ' ' || in == '\t')
						{
							/* case: whitespace indent */
							if (in == ' ')
							{
								indent++;
							}

							/* case: tab indent */
							else if (in == '\t')
							{
								indent+=8;
							}

							in = yyinput();
						}

						/* push back last unmatched char */
						unput(in);

						/* if indent level matches stack peek there's nothing to do */

						if (stack.peek() < indent)
						{
							stack.push(indent);
							std::cout << "INDENT ";

						}

						else if (stack.peek() > indent)
						{
							int dedents = stack.peek();
							/* pop stack's indent levels until match */
							while (stack.peek() != indent)
							{
								if (stack.isEmpty())
								{
									std::cout << std::endl;
									std::cout << "File \"" << yyin << "\", line " << new_line << std::endl;
									std::cout << "Indent error: unindent does not match any outer indentation level" << std::endl;
									yyterminate();
								}

								stack.pop();
							}

							/* matched unindent level */
							std::cout << "DEDENT ";
						}
					}

"<<EOF>>"	{
				if (stack.peek() != 0)
				{
					stack.pop();
					yyless(yyleng);
					std::cout<< "DEDENT";
				}
			}

%%

int main(int argc, char *argv[])
{
	BEGIN(START);

	/* push zero to stack as proposed in Python documentation */
	stack.push(0);

	if (argc > 1)
	{
		yyin = fopen(argv[1], "r");
	} 
	else
	{
		yyin = stdin;
	}

	// output.open("pylex.pyl");
	yylex();
	std::cout << std::endl;
	// output.close();	
}
