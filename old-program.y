/* vim: ft=yacc
 */


 
%{

//#include <cmath> // for pow() in the original version of this
#include <iostream>
#include <FlexLexer.h>
#include "node.hpp"
#include <vector>
//using namespace std;
using std::cerr;
using std::cout;
using std::endl;
using std::vector;
/*
 * These are declared in "main" so that we can pass values between
 * the two portions of the program.
 */

extern unsigned int column;
extern Node *tree;
extern yyFlexLexer scanner;
extern vector<Node*> nodeVec;
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

%token NEWLINE
%token LAB
%token RAB
%token<ttype> SINGLE_ERROR
%token<ttype> WORD_ERROR
%token<ttype> LBR
%token<ttype> RBR
%token<ttype> BRACKETS
%token PAREN
%token DOT
//%type<ttype> newline
%token<ttype> THIS
%token<ttype> NEW
%token<ttype> NLL
%token<ttype> READ
%token<ttype> INT
%token SEMI
%token<ttype> FLOAT
%token<ttype> SCIENTIFIC
%token<ttype> IDENTIFIER
%type<ttype> NewExpression
%type<ttype> exp
%type<ttype> Type
%type<ttype> SimpleType //mod2
%type<ttype> VarDeclaration //mod2
%type<ttype> MultiBrackets
%type<ttype> MultiArrays
%type<ttype> Element
%type<ttype> Assignment
%type<ttype> Name //mod2
%token<ttype> INTEGER 
%token RPAREN LPAREN
%left COMPARE_EQUAL COMPARE_NOTEQUAL LESSOREQUAL GREATEROREQUAL LESSTHAN GREATERTHAN
%left PLUS MINUS COMPARE_OR
%left TIMES DIV MOD COMPARE_AND    /* shift-reduce errors are solved by this */
//%left TIMES DIV     /* shift-reduce errors are solved by this */
%precedence NEG POS NOT     /* exponentiation */
//%right EXP          /* negation--unary minus, not using right now*/

%% /* The grammar follows.  */

Program: Assignment              {tree = $1;}
;
Assignment:   Element            {
	                         $$ = $1;
	                         }
       | Assignment Element      {
                                 $$ = new Node($1, $2);
                                 $$->setval("");
                                 }
;
Element:  VarDeclaration  {$$ = $1; $$->setval(" ");}
       | exp              {
                          $$ = new Node($1, 0);
                          $$->setval(" ");
                          }
       | NEWLINE          { 
                           Node* newLineNode = new Node;
                           newLineNode->setval("\n");
                           $$= newLineNode;
                           $$->setval("");
                           }/*
       | exp error NEWLINE                    { 
                                                 yyclearin;
                                                 Node* newLineNode = new Node;
                                                 newLineNode->setval("\n");
                                                 $$= new Node($$, newLineNode);
              					 nodeInfo* nodeLine = new nodeInfo(scanner.lineno()-1);
                                                 nodeInfo* nodeColumn = new nodeInfo(column);
                                                 Node* details = new nodeDetails(nodeLine, nodeColumn);
                                                 Node* message = new Node;
                                                 message->setval("UNKNOWN ERROR: ");
                                                 Node* nodeErrorMessage = new Node(message, details);
                                            //     Node* temp = new Node($1, $2);
                                             //    temp->setval(" ");
                                             //    Node* temp2 = new Node(temp, $3);
                                            //     Node* temp3 = new Node(temp2, temp);
                                                 column = 1;
                                                 nodeVec.push_back(nodeErrorMessage);
                                       }
       | error exp NEWLINE                    { 
                                                 yyclearin;
                                                 Node* newLineNode = new Node;
                                                 newLineNode->setval("\n");
                                                 $$= new Node($$, newLineNode);
              					 nodeInfo* nodeLine = new nodeInfo(scanner.lineno()-1);
                                                 nodeInfo* nodeColumn = new nodeInfo(column);
                                                 Node* details = new nodeDetails(nodeLine, nodeColumn);
                                                 Node* message = new Node;
                                                 message->setval("UNKNOWN ERROR: ");
                                                 Node* nodeErrorMessage = new Node(message, details);
                                            //     Node* temp = new Node($1, $2);
                                             //    temp->setval(" ");
                                             //    Node* temp2 = new Node(temp, $3);
                                            //     Node* temp3 = new Node(temp2, temp);
                                                 column = 1;
                                                 nodeVec.push_back(nodeErrorMessage);
                                       }*/
       | error NEWLINE                     {
                                                 $$ ->setval(" "); 
                                                 Node* newLineNode = new Node;
                                                 newLineNode->setval("\n");
                                                 $$= new Node($$, newLineNode);
              					 nodeInfo* nodeLine = new nodeInfo(scanner.lineno()-1);
                                                 nodeInfo* nodeColumn = new nodeInfo(column);
                                                 Node* details = new nodeDetails(nodeLine, nodeColumn);
                                                 Node* message = new Node;
                                                 message->setval("UNKNOWN ERROR: ");
                                                 Node* nodeErrorMessage = new Node(message, details);
                                                 Node* temp = new Node($$, 0);
                                                 temp->setval(" ");
                                                 Node* temp2 = new Node(nodeErrorMessage, temp);
                                                 column = 1;
                                                 nodeVec.push_back(temp2);
                                       }/*
       | error VarDeclaration NEWLINE             { 
                                                 yyclearin;
                                                 Node* newLineNode = new Node;
                                                 newLineNode->setval("\n");
                                                 $$= new Node($$, newLineNode);
              					 nodeInfo* nodeLine = new nodeInfo(scanner.lineno()-1);
                                                 nodeInfo* nodeColumn = new nodeInfo(column);
                                                 Node* details = new nodeDetails(nodeLine, nodeColumn);
                                                 Node* message = new Node;
                                                 message->setval("UNKNOWN ERROR: ");
                                                 Node* nodeErrorMessage = new Node(message, details);
                                            //     Node* temp = new Node($1, $2);
                                             //    temp->setval(" ");
                                             //    Node* temp2 = new Node(temp, $3);
                                            //     Node* temp3 = new Node(temp2, temp);
                                                 column = 1;
                                                 nodeVec.push_back(nodeErrorMessage);
                                       }
       | VarDeclaration error NEWLINE                     { 
                                                 yyclearin;
                                                 Node* newLineNode = new Node;
                                                 newLineNode->setval("\n");
                                                 $$= new Node($$, newLineNode);
              					 nodeInfo* nodeLine = new nodeInfo(scanner.lineno()-1);
                                                 nodeInfo* nodeColumn = new nodeInfo(column);
                                                 Node* details = new nodeDetails(nodeLine, nodeColumn);
                                                 Node* message = new Node;
                                                 message->setval("UNKNOWN ERROR: ");
                                                 Node* nodeErrorMessage = new Node(message, details);
                                            //     Node* temp = new Node($1, $2);
                                             //    temp->setval(" ");
                                             //    Node* temp2 = new Node(temp, $3);
                                            //     Node* temp3 = new Node(temp2, temp);
                                                 column = 1;
                                                 nodeVec.push_back(nodeErrorMessage);
                                       }*/
       | VarDeclaration NEWLINE { Node* newLineNode = new Node;
                                 newLineNode->setval("\n"); 
                                 $$= new Node($1,newLineNode);
                                 column = 1;
                                    
                               }
       | exp NEWLINE          { Node* newLineNode = new Node;
                                 newLineNode->setval("\n"); 
                                 $$= new Node($1,newLineNode);
                                    
                                                 column = 1;
                               }
;

VarDeclaration:   Type IDENTIFIER SEMI                    {
                                                            $$ = new Node($1, $2);
                                                            $$->setval(" ");
                                                            Node* semi = new Node;
                                                            semi->setval(";");
                                                            $$ = new Node($$, semi);	
                                                            }
                 | IDENTIFIER IDENTIFIER SEMI               {
                                                          //  $$ = new nodeVarDec($1,$2);
                                                          //  $$->setval(" ");
                                                            $$ = new Node($1, $2);
                                                            $$->setval(" ");
                                                            Node* semi = new Node;
                                                            semi->setval(";");
                                                            $$ = new Node($$, semi);	
                                                            }
                 | IDENTIFIER MultiBrackets IDENTIFIER SEMI {
                                                            $$ = new Node($1, $2);
                                                            $$->setval(" ");
                                                            $$ = new Node($$, $3);
                                                            $$->setval(" "); 
                                                            Node* semi = new Node;
                                                            semi->setval(";");
                                                            $$ = new Node($$, semi);	
                                                            }
;

MultiBrackets: BRACKETS               { $$ =$1;}
	     | MultiBrackets BRACKETS {$$ = new nodeType($1, $2);
                                       $$->setval("");
                                      }
;

Type:   SimpleType 	{
                          $$ = $1;	
                        }
       | Type BRACKETS    { 
                          $$ = new nodeType($1, $2);
                          $$->setval(""); 
                        }/* 
       | error BRACKETS         {yyerrok;yyerror("declaration error"); yyclearin;      
                             nodeInfo* nodeLine = new nodeInfo(scanner.lineno()-1);
                             nodeInfo* nodeColumn = new nodeInfo(column-3);
                             Node* details = new nodeDetails(nodeLine, nodeColumn);
                             Node* message = new Node;
                             message->setval("TYPE ERROR: ");
                             Node* nodeErrorMessage = new Node(message, details);
                             //     Node* temp = new Node($1, $2);
                             //    temp->setval(" ");
                             //    Node* temp2 = new Node(temp, $3);
                             //     Node* temp3 = new Node(details, temp);
                             nodeVec.push_back(nodeErrorMessage);
                             }*/
;
SimpleType:   INT       { 
                        $$ = $1;	
                        }
;
Name:   THIS 		{ 
                          $$ = $1;	
                        }
       | IDENTIFIER    { 
                        $$ = $1; 
                        }
       | Name DOT IDENTIFIER  { 
                        $$ = new Node($1, $3);
                        $$ -> setval("."); 
                        }
       | Name LBR exp RBR   { 
                         $$ = new nodeName($1, $3);
                        }
;
exp:  Name 		{
                        $$ = $1;	
                        }
       | INTEGER 	{ 
                        $$ = new nodeNum($1->getint()); delete $1;	
                        }
       | NLL     	{ 
                        $$ = $1;
                        }
       | READ PAREN  	{ 
                          $1->setval("read()");
                          $$ = $1;	
                        }
       | NewExpression 	{ 
                          $$ = $1;	
                        }
       | PLUS exp %prec POS    { 
                          Node* plus = new nodePlus($2, 0);
                          $$ = new Node($$, plus);
                        }
       | MINUS exp %prec NEG  { 
                          Node* minus = new nodeMinus($2, 0);
                          $$ = new Node($$, minus);
                        }
       | NOT exp %prec NOT    {
                          Node* nt = new nodeNot($2, 0);
                          $$ = new Node($$, nt);
                        }
       | exp COMPARE_EQUAL exp     { 
                        $$ = new Node($1, $3);
                        $$->setval("=="); 
                        }
       | exp COMPARE_NOTEQUAL exp     { 
                        $$ = new Node($1, $3);
                        $$->setval("!="); 
                        }
       | exp LESSOREQUAL exp     { 
                        $$ = new Node($1, $3);
                        $$->setval("<="); 
                        }
       | exp GREATEROREQUAL exp     { 
                        $$ = new Node($1, $3);
                        $$->setval(">="); 
                        }
       | exp LESSTHAN exp     { 
                        $$ = new Node($1, $3);
                        $$->setval("<"); 
                        }
       | exp GREATERTHAN exp     { 
                        $$ = new Node($1, $3);
                        $$->setval(">"); 
                        }
       | exp PLUS exp     { 
                        $$ = new Node($1, $3);
                        $$->setval("+");
                         } 
       | exp MINUS exp     { 
                        $$ = new Node($1, $3);
                        $$->setval("-"); 
                        }
       | exp COMPARE_OR exp     { 
                        $$ = new Node($1, $3);
                        $$->setval("||"); 
                        }
       | exp DIV exp     { 
                        $$ = new Node($1, $3);
                        $$->setval("/"); 
                        }
       | exp TIMES exp     { 
                        $$ = new Node($1, $3);
                        $$->setval("*"); 
                        }
       | exp MOD exp     { 
                        $$ = new Node($1, $3);
                        $$->setval("%"); 
                        }
       | exp COMPARE_AND exp     { 
                        $$ = new Node($1, $3);
                        $$->setval("&&"); 
                        }
       | LPAREN exp RPAREN    { 
                         $$ = new nodeParExp($2);	
                        }
;
NewExpression: NEW IDENTIFIER PAREN {
                           //  $$ = new nodeNewExp1($1, $2);
                              $$ = new Node($1, $2);
                              $$->setval(" ");
                              Node* paren = new Node;
                              paren->setval("()");
                              $$ = new Node($$, paren);
                              $$->setval("");
                             }
	       | NEW IDENTIFIER     { 
                                    $$ = new Node($1, $2);
                                    $$ -> setval(" ");	
                                    }
               | NEW IDENTIFIER MultiArrays              {
                                                         $$ = new Node($1, $2);
                                                         $$->setval(" ");
                                                         $$ = new Node($$, $3);
                                                         $$->setval("");
                                                         }
               | NEW IDENTIFIER MultiBrackets            {
                                                         $$ = new Node($1, $2);
                                                         $$->setval(" ");
                                                         $$ = new Node($$, $3);
                                                         $$->setval("");
                                                         }
               | NEW IDENTIFIER MultiArrays MultiBrackets {
                                                         $$ = new Node($1, $2);
                                                         $$->setval(" ");
                                                         $$ = new Node($$, $3);
                                                         $$->setval("");
                                                         $$ = new Node($$, $4);
                                                         $$->setval("");
                                                         }
;
MultiArrays: LBR exp RBR            {
	                            $$ = new nodeArray($2, 0);
                                    $$->setval("");
                                    }
	  | MultiArrays LBR exp RBR 
                                    {
                                    $$ = new nodeArray($3, 0);
                                    $$ = new Node($1,$$);
                                    $$->setval("");
                                    }
;/* 
newline: NEWLINE               { Node* newLineNode = new Node;
                                 newLineNode->setval("\n"); 
                                 $$= new Node($$,newLineNode);
                                 column = 1;
                               }
;*/
%%
