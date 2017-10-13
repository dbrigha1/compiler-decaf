/* vim: ft=yacc
 */

%{

//#include <cmath> // for pow() in the original version of this
#include <iostream>
#include <FlexLexer.h>
#include "node.hpp"
//using namespace std;
using std::cerr;
using std::cout;
using std::endl;

/*
 * These are declared in "main" so that we can pass values between
 * the two portions of the program.
 */

extern Node *tree;
extern yyFlexLexer scanner;

/* 
 * Need to do this define, an "acceptable" hack to interface
 * the C++ scanner with the C parser. 
 */

#define yylex() scanner.yylex()

// need the function prototype for the parser.

void yyerror(const char *);

%}

%union {
  Node *ttype;
}

/* 
 * Bison declarations.  All the 'names' here will be put into an enum
 * in the *.tab.h file. Include that in the .l/.lpp file and then "return NUM;"
 * passes back the value. 
 *
 * To assign pass the parser a value, say for NUM, you must use 
 * yylval.ttype in the scanner. You could have a number of things in the union
 * but do not get cute. pointers, char, int, double. DO NOT use a class or 
 * struct. 
 *
 * The "exp" is only used here in this file but must be given a type if 
 *(in this case) it is ever assigned a value. See the rules.
 */
%type<ttype> exp
%token<ttype> INTEGER 
%token RPAREN LPAREN
%left PLUS MINUS    /* shift-reduce errors are solved by this */
%left TIMES DIV     /* shift-reduce errors are solved by this */
%precedence NEG     /* exponentiation */
%right EXP          /* negation--unary minus, not using right now*/

%% /* The grammar follows.  */
input:  exp	        {
                        /* 
                         * We have reached the end of the input and
                         * now we are passing the results to the main function.
                         */
                        tree=$1;
                        //cout << "DONE: " << $1->getint() << endl;
                        }
;

exp:   INTEGER 		{ 
                        cout << "INTEGER : " << $1->getint() << endl;        
                        $$=new nodeNum($1->getint()); delete $1; 
                        }
       | exp PLUS exp   { 
                        //cout << "e + e : ";
                        //cout << $1->getint() << " + " << $3->getint() << endl; 
                        $$=new Node($1,$3);
                        $$->setval(" + ");
                        }
       | exp MINUS exp  { 
                        //cout << "e - e : ";
                        //cout << $1->getint() << " - " << $3->getint() << endl; 
                        $$=new Node($1,$3);
                        $$->setval(" - ");
                        }
       | exp TIMES exp  { 
                        //cout << "e * e : ";
                        //cout << $1->getint() << " * " << $3->getint() << endl; 
                        $$=new Node($1,$3);
                        $$->setval(" * ");
                        }
       | exp DIV exp    { 
                        //cout << "e / e : ";
                        //cout << $1->getint() << " / " << $3->getint() << endl; 
                        $$=new Node($1,$3);
                        $$->setval(" / ");
                        }
       | exp EXP exp    { 
                        //cout << "e ^ e : " ;
                        //cout << $1->getint() << " ^ " << $3->getint() << endl; 
                        $$=new Node($1,$3); 
                        }
       | MINUS exp  %prec NEG { 
                        //cout << "- e : " << $2->getint() << endl;       
                        $$=new nodeMinus($2);
                        }
       | LPAREN exp RPAREN    { 
                        //cout << "(e) :" << $2->getint() << endl;        
                        $$=new nodeParExp($2);
                        }
;

%%
