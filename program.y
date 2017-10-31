/*vim: ft=yacc
   program.y
   Dylan Brigham
   Compilers
   10-20-17
   HMK04
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
Node* errorTree;
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

%token NEWLINE
%token<ttype> LAB
%token<ttype> RAB
%token<ttype> DOT
%token<ttype> COMMA
%token<ttype> SEMI
%token<ttype> CLASS
%token<ttype> LBRACE
%token<ttype> RBRACE
%token<ttype> VOID
%token<ttype> EQUALS
%token<ttype> PRINT
%token<ttype> SINGLE_ERROR
%token<ttype> WORD_ERROR
%token<ttype> LBR
%token<ttype> RBR
%token<ttype> BRACKETS
%token<ttype> PAREN
%token<ttype> THIS
%token<ttype> NEW
%token<ttype> NLL
%token<ttype> READ
%token<ttype> INT
%token<ttype> FLOAT
%token<ttype> SCIENTIFIC
%token<ttype> IDENTIFIER
%type<ttype> ClassDeclaration
%type<ttype> ClassBody
%type<ttype> ConstructorDeclaration
%type<ttype> MethodDeclaration
%type<ttype> MultiVarDec 
%type<ttype> MultiConstructorDec 
%type<ttype> MultiMethodDec
%type<ttype> MultiLocalVarDec 
%type<ttype> MultiStatement
%type<ttype> ResultType
%type<ttype> ParameterList
%type<ttype> Parameter
%type<ttype> Block
%type<ttype> LocalVarDeclaration
%type<ttype> Statement
%type<ttype> NewExpression
%type<ttype> exp
%type<ttype> Type
%type<ttype> SimpleType //mod2
%type<ttype> VarDeclaration //mod2
%type<ttype> MultiBrackets
%type<ttype> MultiArrays
//%type<ttype> Element
//%type<ttype> Assignment
%type<ttype> Name //mod2
%token<ttype> INTEGER 
%token<ttype> RPAREN LPAREN
%left COMPARE_EQUAL COMPARE_NOTEQUAL LESSOREQUAL GREATEROREQUAL LESSTHAN GREATERTHAN
%left PLUS MINUS COMPARE_OR
%left TIMES DIV MOD COMPARE_AND    /* shift-reduce errors are solved by this */
%precedence NEG POS NOT     /* exponentiation */

%% /* The grammar follows.  */

Program: ClassDeclaration              {tree = $1;}
;
ClassDeclaration:   CLASS IDENTIFIER ClassBody     {
		                                   Node* temp = new Node($1, $2);
                                                   $$ = new Node(temp, $3);
                                                   }     
;
ClassBody: LBRACE RBRACE                                                    {$$ = new Node($1,$2);}
         | LBRACE MultiVarDec RBRACE                                        {
                                                                             Node* temp = new Node($1, $2);
                                                                             $$ = new Node(temp, $3);  
                                                                            }
         | LBRACE MultiConstructorDec RBRACE                                {
                                                                             Node* temp = new Node($1, $2);
                                                                             $$ = new Node(temp, $3);  
                                                                            }
         | LBRACE MultiMethodDec RBRACE                                     {
                                                                             Node* temp = new Node($1, $2);
                                                                             $$ = new Node(temp, $3);  
                                                                            }
         | LBRACE MultiVarDec MultiConstructorDec RBRACE                    {
                                                                             Node* temp = new Node($1, $2);
                                                                             Node* temp2 = new Node(temp, $3);
                                                                             $$ = new Node (temp2, $4); 
                                                                            }
         | LBRACE MultiVarDec MultiMethodDec RBRACE                         {
                                                                             Node* temp = new Node($1, $2);
                                                                             Node* temp2 = new Node(temp, $3);
                                                                             $$ = new Node (temp2, $4); 

                                                                            }
         | LBRACE MultiConstructorDec MultiMethodDec RBRACE                 {
                                                                             Node* temp = new Node($1, $2);
                                                                             Node* temp2 = new Node(temp, $3);
                                                                             $$ = new Node (temp2, $4); 

                                                                            } 
         | LBRACE MultiVarDec MultiConstructorDec MultiMethodDec RBRACE     {
                                                                             Node* temp = new Node($1, $2);
                                                                             Node* temp2 = new Node(temp, $3);
                                                                             Node* temp3 = new Node (temp2, $4);
                                                                             $$ = new Node(temp3, $5);
                                                                            }
         ;
MultiVarDec: VarDeclaration                                                 {$$ = $1; $$->setval(" ");}
           | MultiVarDec VarDeclaration                                     {$$ = new nodeType($1, $2); $$->setval("");}
           ;
MultiConstructorDec: ConstructorDeclaration                                 {$$ = $1; $$->setval(" ");}
                   | MultiConstructorDec ConstructorDeclaration             {$$ = new nodeType($1, $2); $$->setval("");}
                   ;
MultiMethodDec: MethodDeclaration                                   {$$ = $1; $$->setval(" ");}
                      | MultiMethodDec MethodDeclaration            {$$ = new nodeType($1, $2); $$->setval("");}
                      ;
ConstructorDeclaration: IDENTIFIER LPAREN ParameterList RPAREN Block        {
                                                                            Node* temp = new Node($1, $2);
                                                                            Node* temp2 = new Node(temp, $3);
                                                                            Node* temp3 = new Node(temp2, $4);
                                                                            $$ = new Node(temp3, $5);
                                                                            }
                      ;
MethodDeclaration: ResultType IDENTIFIER LPAREN ParameterList RPAREN Block  {
                                                                            Node* temp = new Node($1, $2);
                                                                            Node* temp2 = new Node(temp, $3);
                                                                            Node* temp3 = new Node(temp2, $4);
                                                                            Node* temp4 = new Node(temp3, $5);
                                                                            $$ = new Node(temp4, $6);
                                                                            }
                 ;
ResultType: Type              {$$ = $1;}
          | VOID              {$$ = $1;}
          ;
ParameterList: Parameter                                                {$$ = $1;}
             | ParameterList COMMA Parameter                            {
                                                                         Node* temp = new Node($1, $2);
                                                                         $$ = new Node(temp, $3);                                                                         
                                                                        }
             ;
Parameter: Type IDENTIFIER                                              {$$ = new Node($1, $2);}
         ;
Block: LBRACE RBRACE                                                    {$$ = new Node($1, $2);}
     | LBRACE MultiLocalVarDec RBRACE                                   {
                                                                         Node* temp = new Node($1, $2);
                                                                         $$ = new Node(temp, $3);  
                                                                        }
     | LBRACE MultiStatement RBRACE                                     {
                                                                         Node* temp = new Node($1, $2);
                                                                         $$ = new Node(temp, $3);  
                                                                        }
     | LBRACE MultiLocalVarDec MultiStatement RBRACE                    {
                                                                         Node* temp = new Node($1, $2);
                                                                         Node* temp2 = new Node(temp, $3);
                                                                         $$ = new Node(temp2, $4);  
                                                                        }
     ;
MultiLocalVarDec: LocalVarDeclaration                                           {$$ = $1; $$->setval(" ");}
                | MultiLocalVarDec LocalVarDeclaration                          {$$ = new nodeType($1, $2); $$->setval("");}
                ;
MultiStatement: Statement                                               {$$ = $1; $$->setval(" ");}
              | MultiStatement Statement                                {$$ = new nodeType($1, $2); $$->setval("");}
              ;
LocalVarDeclaration: Type IDENTIFIER SEMI       {Node* temp = new Node($1, $2); $$ = new Node(temp, $3);}
;
Statement: SEMI                             {$$ = $1;}
         | Name EQUALS exp                  {Node* temp = new Node($1, $2); $$ = new Node(temp, $3);}
         | Block                            {$$ = $1;}
;
VarDeclaration:   Type IDENTIFIER SEMI                    {
                                                            $$ = new Node($1, $2);
                                                            $$->setval(" ");
                                                            Node* semi = new Node;
                                                            semi->setval(";");
                                                            $$ = new Node($$, semi);	
                                                            }/*
       | error SEMI                     {//if an error is read it will continue until
                                            //a newline character is recognized
                                                 yyerrok; yyclearin;
              					 nodeInfo* nodeLine = new nodeInfo(scanner.lineno());
                                                 Node* details = new nodeDetails(nodeLine, 0);
                                                 Node* message = new Node;
                                                 message->setval("Variable Declaration error: ");
                                                 Node* nodeErrorMessage = new Node(message, details);
                                                 Node* semi = new Node; semi->setval(";");
                                                 Node* err = new Node; err->setval("?");
                                                 Node* example = new Node(err, semi);
                                                 example->setval("");
                                                 Node* total = new Node(nodeErrorMessage,example); 
                                                 
                                                 nodeVec.push_back(total);
                                       }*/
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
       | error BRACKETS                     {
                                             yyerrok; yyclearin;
                                             Node* er  = new Node;
                                             er->setval("?");
                                             //if an error is read it will continue until
                                            //a newline character is recognized
                                                
              					 nodeInfo* nodeLine = new nodeInfo(scanner.lineno());
                                               //  nodeInfo* nodeColumn = new nodeInfo(column);
                                          //       yyerror($1);
                                                 Node* details = new nodeDetails(nodeLine, 0);
                                                 Node* message = new Node;
                                                 message->setval("Type error: ");
                                                 Node* nodeErrorMessage = new Node(message, details);
                                                 Node* example = new Node(er, $2);
                                                 example->setval("");
                                               //  Node* semi = new Node;
                                              //   semi->setval(";");
                                                 Node* temp2 = new Node(nodeErrorMessage, example); 
                                              //   Node* temp3 = new Node(nodeErrorMessage, $1);
                                                 
                                                 nodeVec.push_back(temp2);
                                       }*/
;
SimpleType: INT       {$$ = $1;}
          | IDENTIFIER {$$ =$1;}  
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
                        //  $$ = new Node($$, plus);
                          $$ = plus;
                        }
       | MINUS exp %prec NEG  { 
                          Node* minus = new nodeMinus($2, 0);
                         // $$ = new Node($$, minus);
                            $$ = minus;
                        }
       | NOT exp %prec NOT    {
                          Node* nt = new nodeNot($2, 0);
                        //  $$ = new Node($$, nt);
                            $$ = nt;
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
      /* | LPAREN error                   {
                                                 yyerrok; yyclearin;
                                               //  Node* newLineNode = new Node;
                                               //  newLineNode->setval("\n"); 
                                               //  column = 1;
              				     	 nodeInfo* nodeLine = new nodeInfo(scanner.lineno()-1);
                                                 Node* details = new nodeDetails(nodeLine, 0);
                                                 Node* message = new Node;
                                                 message->setval("Missing right parenthesis: ");
                                                 Node* nodeErrorMessage = new Node(message, details);
                                                 Node* err = new Node; err->setval("?");
                                                 Node* total = new Node(nodeErrorMessage,err); 
                                                 nodeVec.push_back(total);
                                       }
       |  error NEWLINE                    {//if an error is read it will continue until
                                            //a newline character is recognized
                                                 yyerrok; yyclearin;
                                                 Node* newLineNode = new Node;
                                                 newLineNode->setval("\n"); 
                                                 $$= newLineNode;
                                                 column = 1;
              					 nodeInfo* nodeLine = new nodeInfo(scanner.lineno()-1);
                                                 Node* details = new nodeDetails(nodeLine, 0);
                                                 Node* message = new Node;
                                                 message->setval("Expression error: ");
                                                 Node* nodeErrorMessage = new Node(message, details);
                                                 Node* err = new Node; err->setval("?");
                                                 Node* total = new Node(nodeErrorMessage,err); 
                                                 nodeVec.push_back(total);
                                       }*/
;
NewExpression: NEW IDENTIFIER PAREN {
                           //  $$ = new nodeNewExp1($1, $2);
                              Node* expNode = new Node($1, $2);
                              expNode->setval(" ");
                              Node* paren = new Node;
                              paren->setval("()");
                              $$ = new Node(expNode, paren);
                              $$->setval("");
                             }
	       | NEW IDENTIFIER     { 
                                    $$ = new Node($1, $2);
                                    $$ -> setval(" ");	
                                    }
               | NEW IDENTIFIER MultiArrays              {
                                                         
                                                         Node* expNode = new Node($1, $2);
                                                         expNode->setval(" ");
                                                         $$ = new Node(expNode, $3);
                                                         $$->setval("");
                                                         }
               | NEW IDENTIFIER MultiBrackets            {
                                                         Node* expNode = new Node($1, $2);
                                                         expNode->setval(" ");
                                                         $$ = new Node(expNode, $3);
                                                         $$->setval("");
                                                         }
               | NEW IDENTIFIER MultiArrays MultiBrackets {
                                                         Node* expNode = new Node($1, $2);
                                                         expNode->setval(" ");
                                                         Node* expNode2 = new Node(expNode, $3);
                                                         expNode2->setval("");
                                                         $$ = new Node(expNode2, $4);
                                                         $$->setval("");
                                                         }/*
       | NEW error NEWLINE                    {//if an error is read it will continue until
                                            //a newline character is recognized
                                                 yyerrok; yyclearin;
                                                 Node* newLineNode = new Node;
                                                 newLineNode->setval("\n"); 
                                                 $$= newLineNode;
                                                 column = 1;
              					 nodeInfo* nodeLine = new nodeInfo(scanner.lineno()-1);
                                                 Node* details = new nodeDetails(nodeLine, 0);
                                                 Node* message = new Node;
                                                 message->setval("New Expression error: ");
                                                 Node* nodeErrorMessage = new Node(message, details);
                                                 Node* err = new Node; err->setval("New ?");
                                                 Node* total = new Node(nodeErrorMessage,err); 
                                                 nodeVec.push_back(total);
                                       }*/
;
MultiArrays: LBR exp RBR            {
	                            $$ = new nodeArray($2, 0);
                                    $$->setval("");
                                    }
	  | MultiArrays LBR exp RBR 
                                    {
                                    Node* expNode = new nodeArray($3, 0);
                                    $$ = new Node($1,expNode);
                                    $$->setval("");
                                    }
; 
%%
