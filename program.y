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
#include "scope.h"
#include "symbolTable.h"
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

//%token IFX
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
%token<ttype> IF
%token<ttype> ELSE
%token<ttype> WHILE
%token<ttype> RETURN
%token<ttype> THIS
%token<ttype> NEW
%token<ttype> NLL
%token<ttype> READ
%token<ttype> INT
%token<ttype> FLOAT
%token<ttype> SCIENTIFIC
%token<ttype> IDENTIFIER
%token<ttype> NOT
%type<ttype> Arglist
%type<ttype> ConditionalStatement
%type<ttype> OptionalExpression
%type<ttype> ClassDeclaration
%type<ttype> ClassBody
%type<ttype> ConstructorDeclaration
%type<ttype> MethodDeclaration
%type<ttype> MultiClassDec
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
%left<ttype> COMPARE_EQUAL COMPARE_NOTEQUAL LESSOREQUAL GREATEROREQUAL LESSTHAN GREATERTHAN
%left<ttype> PLUS MINUS COMPARE_OR
%left<ttype> TIMES DIV MOD COMPARE_AND
%precedence NEG POS NOTTY    
%expect 1
%% /* The grammar follows.  */

Program: MultiClassDec              {
                                       //  $1->setval(" <ClassDeclaration>\n");
                                         Node* temp = new Node($1,0);
                                         temp->setval("<Program> --> <ClassDeclaration>\n");
                                         tree = temp;
                                       
                                       }
;
MultiClassDec: ClassDeclaration                                             {
	                                                                     //$1->setval(" <VarDeclaration>\n");
                                                                             Node* name = new Node($1);
                                                                             name->setval("<MultiClassDec>--><ClassDeclaration>\n");
                                                                             $$ = new Node(name);
                                                                            }
           | MultiClassDec ClassDeclaration                                 {
                                                                             //$1->setval(" <MultiClassDec>\n"); 
                                                                             //$2->setval(" <VarDeclaration>\n");
                                                                             Node* name = new Node($1, $2);
                                                                             name->setval("<MultiClassDec>--><MultiClassDec> <ClassDeclaration>\n");
                                                                             $$ = new Node(name);
                                                                            }
           ;
ClassDeclaration:   CLASS IDENTIFIER ClassBody     {
		                                  // $3->setval(" <ClassBody>\n");
		                                   Node* temp = new Node($1, $2);
                                                   Node* name = new Node(temp, $3);
                                                   name->setval("<ClassDeclaration>--> CLASS IDENTIFIER <ClassBody>\n");
                                                   $$ = new Node(name);
                                                   }     
       | error ClassBody          {
                                                 yyerrok; yyclearin;  
              					 nodeInfo* nodeLine = new nodeInfo(scanner.lineno());
                                                 Node* details = new nodeDetails(nodeLine, 0);
                                                 Node* message = new Node;
                                                 message->setval("ERROR <ClassDeclaration error> end of ClassBody at ");
                                                 Node* nodeErrorMessage = new Node(message, details);
                                                 
                                                 nodeVec.push_back(nodeErrorMessage);
                                                 Node* name = new Node($2);
                                                 name->setval("<ClassDeclaration>--> error <ClassBody>\n");
                                                 $$ = new Node(name);
                                                }
;
ClassBody: LBRACE RBRACE                                                    {
	                                                                    Node* name = new Node($1,$2);
                                                                            name->setval("<ClassBody>--> LBRACE RBRACE\n");
                                                                            $$= new Node(name);
                                                                            }
         | LBRACE MultiVarDec RBRACE                                        {
                                                                           //  $2->setval(" <MultiVarDec>\n");
                                                                             Node* temp = new Node($1, $2);
                                                                             Node* name = new Node(temp, $3);  
                                                                             name->setval("<ClassBody>--> LBRACE <MultiVarDec> RBRACE\n");
                                                                             $$= new Node(name);
                                                                            }
         | LBRACE MultiConstructorDec RBRACE                                {
                                                                            // $2->setval(" <MultiConstructorDec>\n");
                                                                             Node* temp = new Node($1, $2);
                                                                             Node* name = new Node(temp, $3);  
                                                                             name->setval("<ClassBody>--> LBRACE <MultiConstructorDec> RBRACE\n");
                                                                             $$= new Node(name);
                                                                            }
         | LBRACE MultiMethodDec RBRACE                                     {
                                                                          //   $2->setval(" <MultiMethodDec>\n");
                                                                             Node* temp = new Node($1, $2);
                                                                             Node* name = new Node(temp, $3);  
                                                                             name->setval("<ClassBody>-->LBRACE <MultiMethodDec> RBRACE\n");
                                                                             $$= new Node(name);
                                                                            }
         | LBRACE MultiVarDec MultiConstructorDec RBRACE                    {
                                                                            // $2->setval(" <MultiVarDec>\n");
                                                                            // $3->setval(" <MultiConstructorDec>\n");
                                                                             Node* temp = new Node($1, $2);
                                                                             Node* temp2 = new Node(temp, $3);
                                                                             Node* name = new Node (temp2, $4); 
                                                                             name->setval("<ClassBody>-->LBRACE <MultiVarDec> <MultiConstructorDec> RBRACE\n");
                                                                             $$= new Node(name);
                                                                            }
         | LBRACE MultiVarDec MultiMethodDec RBRACE                         {
                                                                           //  $2->setval(" <MultiVarDec>\n");
                                                                           //  $3->setval(" <MultiMethodDec>\n");
                                                                             Node* temp = new Node($1, $2);
                                                                             Node* temp2 = new Node(temp, $3);
                                                                             Node* name = new Node (temp2, $4);
                                                                             name->setval("<ClassBody>-->LBRACE <MultiVarDec> <MultiMethodDec> RBRACE\n");
                                                                             $$ = new Node(name);
                                                                            }
         | LBRACE MultiConstructorDec MultiMethodDec RBRACE                 {
                                                                           //  $2->setval(" <MultiConstructorDec>\n");
                                                                           //  $3->setval(" <MultiMethodDec>\n");
                                                                             Node* temp = new Node($1, $2);
                                                                             Node* temp2 = new Node(temp, $3);
                                                                             Node* name = new Node (temp2, $4); 
                                                                             name->setval("<ClassBody>-->LBRACE <MultiConstructorDec> <MultiMethodDec> RBRACE\n");
                                                                             $$= new Node(name);

                                                                            } 
         | LBRACE MultiVarDec MultiConstructorDec MultiMethodDec RBRACE     {
                                                                            // $2->setval(" <MultiVarDec>\n");
                                                                            // $3->setval(" <MultiConstructorDec>\n");
                                                                            // $4->setval(" <MultiMethodDec>\n");
                                                                             Node* temp = new Node($1, $2);
                                                                             Node* temp2 = new Node(temp, $3);
                                                                             Node* temp3 = new Node (temp2, $4);
                                                                             Node* name = new Node(temp3, $5);
                                                                             name->setval("<ClassBody>-->LBRACE <MultiVarDec> <MultiConstructorDec> <MultiMethodDec> RBRACE\n");
                                                                             $$= new Node(name);
                                                                            }
         ;
MultiVarDec: VarDeclaration                                                 {
	                                                                     //$1->setval(" <VarDeclaration>\n");
                                                                             Node* name = new Node($1);
                                                                             name->setval("<MultiVarDec>--><VarDeclaration>\n");
                                                                             $$ = new Node(name);
                                                                            }
           | MultiVarDec VarDeclaration                                     {
                                                                             //$1->setval(" <MultiVarDec>\n"); 
                                                                             //$2->setval(" <VarDeclaration>\n");
                                                                             Node* name = new Node($1, $2);
                                                                             name->setval("<MultiVarDec>--><MultiVarDec> <VarDeclaration>\n");
                                                                             $$ = new Node(name);
                                                                            }
           ;
MultiConstructorDec: ConstructorDeclaration                                 {
		                                                             //$1->setval(" <ConstructorDeclaration>\n");
                                                                             Node* name = new Node($1);
                                                                             name->setval("<MultiConstructorDec>--><ConstructorDeclaration>\n");
                                                                             $$ = new Node(name);
                                                                            }
                   | MultiConstructorDec ConstructorDeclaration             {
                                                                             //$1->setval(" <MultiConstructorDec>\n");
                                                                             //$2->setval(" <ConstructorDeclaration>\n");
                                                                             Node* name = new Node($1, $2);
                                                                             name->setval("<MultiConstructorDec>--><MultiConstructorDec> <ConstructorDeclaration>\n");
                                                                             $$ = new Node(name);
                                                                            }
                   ;
MultiMethodDec: MethodDeclaration                                           {
		                                                             //$1->setval(" <MethodDeclaration>\n");
                                                                             Node* name = new Node($1);
                                                                             name->setval("<MultiMethodDec>--><MethodDeclaration>\n");
                                                                             $$ = new Node(name);
                                                                            }
                      | MultiMethodDec MethodDeclaration                    {
                                                                             //$1->setval(" <MultiMethodDec>\n");
                                                                             //$2->setval(" <MethodDeclaration>\n");
                                                                             Node* name = new Node($1, $2);
                                                                             name->setval("<MultiMethodDec>--><MultiMethodDec> <MethodDeclaration>\n");
                                                                             $$ = new Node(name);
                                                                            }
                      ;
ConstructorDeclaration: IDENTIFIER LPAREN ParameterList RPAREN Block        {
                                                                            Node* temp = new Node($1, $2);
                                                                            Node* temp2 = new Node(temp, $3);
                                                                            Node* temp3 = new Node(temp2, $4);
                                                                            Node* name = new Node(temp3, $5);
                                                                            name->setval("<ConstructorDeclaration>--> IDENTIFIER LPAREN <ParameterList> RPAREN <Block>\n");
                                                                            $$ = new Node(name);
                                                                            }
                      | IDENTIFIER LPAREN RPAREN Block                      {
                                                                            Node* temp = new Node($1, $2);
                                                                            Node* temp2 = new Node(temp, $3);
                                                                            Node* name = new Node(temp2, $4);
                                                                            name->setval("<ConstructorDeclaration>--> IDENTIFIER LPAREN RPAREN <Block>\n");
                                                                            $$ = new Node(name);
                                                                            }
       | IDENTIFIER error Block           {
                                                 yyerrok; yyclearin; 
              					 nodeInfo* nodeLine = new nodeInfo(scanner.lineno());
                                                 Node* details = new nodeDetails(nodeLine, 0);
                                                 Node* message = new Node;
                                                 message->setval("ERROR <Constructor Declaration error> ");
                                                 Node* nodeErrorMessage = new Node(message, details);
                                                 
                                                 nodeVec.push_back(nodeErrorMessage);
                                                 Node* name = new Node($1, $3);
                                                 name->setval("<ConstructorDeclaration>--> IDENTIFIER error <Block>\n");
                                                 $$ = new Node(name);
                                                }
                      ;
MethodDeclaration: ResultType IDENTIFIER LPAREN ParameterList RPAREN Block  {
                                                                            Node* temp = new Node($1, $2);
                                                                            Node* temp2 = new Node(temp, $3);
                                                                            Node* temp3 = new Node(temp2, $4);
                                                                            Node* temp4 = new Node(temp3, $5);
                                                                            Node* name = new Node(temp4, $6);
                                                                            name->setval("<MethodDeclaration>--> <ResultType> IDENTIFIER LPAREN <ParameterList> RPAREN <Block>\n");
                                                                            $$ = new Node(name);
                                                                            }
                 | ResultType IDENTIFIER LPAREN RPAREN Block                {
                                                                            Node* temp = new Node($1, $2);
                                                                            Node* temp2 = new Node(temp, $3);
                                                                            Node* temp3 = new Node(temp2, $4);
                                                                            Node* name = new Node(temp3, $5);
                                                                            name->setval("<MethodDeclaration>--> <ResultType> IDENTIFIER LPAREN RPAREN <Block>\n");
                                                                            $$ = new Node(name);
                                                                            }
                 | Type IDENTIFIER LPAREN RPAREN Block                {
                                                                            Node* temp = new Node($1, $2);
                                                                            Node* temp2 = new Node(temp, $3);
                                                                            Node* temp3 = new Node(temp2, $4);
                                                                            Node* name = new Node(temp3, $5);
                                                                            name->setval("<MethodDeclaration>--> <ResultType> IDENTIFIER LPAREN RPAREN <Block>\n");
                                                                            $$ = new Node(name);
                                                                            }
                 | Type IDENTIFIER LPAREN ParameterList RPAREN Block       {
                                                                            Node* temp = new Node($1, $2);
                                                                            Node* temp2 = new Node(temp, $3);
                                                                            Node* temp3 = new Node(temp2, $4);
                                                                            Node* temp4 = new Node(temp3, $5);
                                                                            Node* name = new Node(temp4, $6);
                                                                            name->setval("<MethodDeclaration>--> <ResultType> IDENTIFIER LPAREN RPAREN <Block>\n");
                                                                            $$ = new Node(name);
                                                                            }
                 | IDENTIFIER IDENTIFIER LPAREN RPAREN Block                {
                                                                            Node* temp = new Node($1, $2);
                                                                            Node* temp2 = new Node(temp, $3);
                                                                            Node* temp3 = new Node(temp2, $4);
                                                                            Node* name = new Node(temp3, $5);
                                                                            name->setval("<MethodDeclaration>--> IDENTIFIER IDENTIFIER LPAREN RPAREN <Block>\n");
                                                                            $$ = new Node(name);
                                                                            }
                 | IDENTIFIER IDENTIFIER LPAREN ParameterList RPAREN Block                {
                                                                            Node* temp = new Node($1, $2);
                                                                            Node* temp2 = new Node(temp, $3);
                                                                            Node* temp3 = new Node(temp2, $4);
                                                                            Node* temp4 = new Node(temp3, $5);
                                                                            Node* name = new Node(temp4, $6);
                                                                            name->setval("<MethodDeclaration>--> IDENTIFIER IDENTIFIER LPAREN RPAREN <Block>\n");
                                                                            $$ = new Node(name);
                                                                            }
                 | IDENTIFIER MultiBrackets IDENTIFIER LPAREN RPAREN Block                {
                                                                            Node* temp = new Node($1, $2);
                                                                            Node* temp2 = new Node(temp, $3);
                                                                            Node* temp3 = new Node(temp2, $4);
                                                                            Node* temp4 = new Node(temp3, $5);
                                                                            Node* name = new Node(temp4, $6);
                                                                            name->setval("<MethodDeclaration>--> IDENTIFIER <MultiBrackets> IDENTIFIER LPAREN RPAREN <Block>\n");
                                                                            $$ = new Node(name);
                                                                                          }
                 | IDENTIFIER MultiBrackets IDENTIFIER LPAREN ParameterList RPAREN Block 
                                                                           {
                                                   Node* temp = new Node($1, $2);
                                                   Node* temp2 = new Node(temp, $3);
                                                   Node* temp3 = new Node(temp2, $4);
                                                   Node* temp4 = new Node(temp3, $5);
                                                   Node* temp5 = new Node(temp4, $6);
                                                   Node* name = new Node(temp5, $7);
                                                   name->setval("<MethodDeclaration>--> IDENTIFIER <MultiBrackets> IDENTIFIER LPAREN <ParameterList> RPAREN <Block>\n");
                                                                            $$ = new Node(name);
                                                                            }
       | ResultType error Block           {
                                                 yyerrok; yyclearin; 
              					 nodeInfo* nodeLine = new nodeInfo(scanner.lineno());
                                                 Node* details = new nodeDetails(nodeLine, 0);
                                                 Node* message = new Node;
                                                 message->setval("ERROR <Method Declaration error> ");
                                                 Node* nodeErrorMessage = new Node(message, details);
                                                 
                                                 nodeVec.push_back(nodeErrorMessage);
                                                 Node* name = new Node($1, $3);
                                                 name->setval("<ConstructorDeclaration>--> ResultType error <Block>\n");
                                                 $$ = new Node(name);
                                                }
                 ;
ResultType: /*Type              {
                          Node* name = new Node($1);
                          name->setval("<ResultType>--> <Type>\n");
                          $$ = new Node(name);
                              }
          | */VOID              {
                          Node* name = new Node($1);
                          name->setval("<ResultType>--> VOID\n");
                          $$ = new Node(name);
                              }
          ;
ParameterList: Parameter {
                          Node* name = new Node($1);
                          name->setval("<ParameterList>--> <Parameter>\n");
                          $$ = new Node(name);
                         }
             | ParameterList COMMA Parameter                            {
                                                                         Node* temp = new Node($1, $2);
                                                                         Node* name = new Node(temp, $3);                                                                         
                                                                         name->setval("<ParameterList>--> <ParameterList> COMMA <Parameter>\n");
                                                                         $$ = new Node(name);
                                                                        }
       | ParameterList error Parameter           {
                                                 yyerrok; yyclearin; 
              					 nodeInfo* nodeLine = new nodeInfo(scanner.lineno());
                                                 Node* details = new nodeDetails(nodeLine, 0);
                                                 Node* message = new Node;
                                                 message->setval("ERROR <missing comma> ");
                                                 Node* nodeErrorMessage = new Node(message, details);
                                                 
                                                 nodeVec.push_back(nodeErrorMessage);
                                                 Node* name = new Node($1, $3);
                                                 name->setval("<ParameterList>--> <ParameterList> error <Parameter>\n");
                                                 $$ = new Node(name);
                                                }
             ;
Parameter: Type IDENTIFIER                                              {
	                                                                 Node* name = new Node($1, $2);
                                                                         name->setval("<Parameter>--> <Type> IDENTIFIER\n");
                                                                         $$ = new Node(name);
                                                                        }
               | IDENTIFIER IDENTIFIER               {
                                                          //  $$ = new nodeVarDec($1,$2);
                                                          //  $$->setval(" ");
                                                            Node* name = new Node($1, $2); 
                                                            name->setval("<Parameter>--> IDENTIFIER IDENTIFIER\n");
                                                            $$ = new Node(name);	
                                                            }
               | IDENTIFIER MultiBrackets IDENTIFIER               {
                                                          //  $$ = new nodeVarDec($1,$2);
                                                          //  $$->setval(" ");
                                                            Node* temp = new Node($1, $2); 
                                                            Node* name = new Node(temp, $3);
                                                            name->setval("<Parameter>--> IDENTIFIER <MultiBrackets> IDENTIFIER\n");
                                                            $$ = new Node(name);	
                                                            }
         ;
Block: LBRACE RBRACE                                                    {
                                                                         Node* name = new Node($1, $2);
                                                                         name->setval("<Block>--> LBRACE RBRACE\n");
                                                                         $$ = new Node(name);
                                                                        }
     | LBRACE MultiLocalVarDec RBRACE                                    {
                                                                         Node* temp = new Node($1, $2);
                                                                         Node* name = new Node(temp, $3);  
                                                                         name->setval("<Block>--> LBRACE <MultiLocalVarDec> RBRACE\n");
                                                                         $$ = new Node(name);
                                                                        }
     | LBRACE MultiStatement RBRACE                                     {
                                                                         Node* temp = new Node($1, $2);
                                                                         Node* name = new Node(temp, $3);  
                                                                         name->setval("<Block>--> LBRACE <MultiStatement> RBRACE\n");
                                                                         $$ = new Node(name);
                                                                        }
     | LBRACE MultiLocalVarDec MultiStatement RBRACE                    {
                                                                         Node* temp = new Node($1, $2);
                                                                         Node* temp2 = new Node(temp, $3);
                                                                         Node* name = new Node(temp2, $4);  
                                                                         name->setval("<Block>--> LBRACE <MultiLocalVarDec> <MultiStatement> RBRACE\n");
                                                                         $$ = new Node(name);
                                                                        }

       | LBRACE error RBRACE                     {
                                                 yyerrok; yyclearin; 
                                                 nodeInfo* nodeLine = new nodeInfo(scanner.lineno());
                                                 Node* details = new nodeDetails(nodeLine, 0);
                                                 Node* message = new Node;
                                                 message->setval("ERROR <Block> ");
                                                 Node* nodeErrorMessage = new Node(message, details);
                                                 
                                                 nodeVec.push_back(nodeErrorMessage);
                                                 Node* name = new Node($1, $3);
                                                 name->setval("<ConstructorDeclaration>--> LBRACE error RBRACE\n");
                                                 $$ = new Node(name);
                                                }
     ;
MultiLocalVarDec: LocalVarDeclaration                 {
                                                       Node* name = new Node($1);
                                                       name->setval("<MultiLocalVarDec>--> <LocalVarDeclaration>\n");
                                                       $$ = new Node(name);
                                                       }
                | MultiLocalVarDec LocalVarDeclaration                          {
                                                                                Node* name = new Node($1, $2);
                                                                                name->setval("<MultiLocalVarDec>--> <MultiLocalVarDec> <LocalVarDeclaration>\n");
                                                                                $$ = new Node(name);
                                                                                }
                ;
MultiStatement: Statement                                               {
                          Node* name = new Node($1);
                          name->setval("<MultiStatement>--> <Statement>\n");
                          $$ = new Node(name);
	      }
              | MultiStatement Statement                                {
                                                                                Node* name = new Node($1, $2);
                                                                                name->setval("<MultiStatement>--> <MultiStatement> <Statement>\n");
                                                                                $$ = new Node(name);
                                                                        }
              ;
LocalVarDeclaration: Type IDENTIFIER SEMI       {
		                                Node* temp = new Node($1, $2); 
                                                Node* name = new Node(temp, $3);
                                                name->setval("<LocalVarDeclaration>--> <Type> IDENTIFIER SEMI\n");
                                                $$ = new Node(name);
                                                }
               | IDENTIFIER IDENTIFIER SEMI               {
                                                          //  $$ = new nodeVarDec($1,$2);
                                                          //  $$->setval(" ");
                                                            Node* temp = new Node($1, $2); 
                                                            Node* name = new Node(temp, $3);
                                                            name->setval("<LocalVarDeclaration>--> IDENTIFIER IDENTIFIER SEMI\n");
                                                            $$ = new Node(name);	
                                                            }
               | IDENTIFIER MultiBrackets IDENTIFIER SEMI {
                                                            Node* temp = new Node($1, $2); 
                                                            Node* temp2 = new Node(temp, $3);
                                                            Node* name = new Node(temp2, $4);
                                                            name->setval("<LocalVarDeclaration>-->IDENTIFIER <MultiBrackets> IDENTIFIER SEMI\n");
                                                            $$ = new Node(name);	
                                                            }
               | error SEMI                     {
                                                 yyerrok; yyclearin; 
              					 nodeInfo* nodeLine = new nodeInfo(scanner.lineno());
                                                 Node* details = new nodeDetails(nodeLine, 0);
                                                 Node* message = new Node;
                                                 message->setval("ERROR <Variable Declaration error> ");
                                                 Node* nodeErrorMessage = new Node(message, details);
                                                 
                                                 nodeVec.push_back(nodeErrorMessage);
                                                 Node* name = new Node($2);
                                                 name->setval("<ConstructorDeclaration>--> error SEMI\n");
                                                 $$ = new Node(name);
                                                }
;
Statement: SEMI                              {
                          Node* name = new Node($1);
                          name->setval("<Statement>--> SEMI\n");
                          $$ = new Node(name);
	 }
         | Name EQUALS exp                   {
                                             Node* temp = new Node($1, $2); 
                                             Node* name = new Node(temp, $3);
                                             name->setval("<Statement>--> <Name> EQUALS <exp>\n");
                                             $$ = new Node(name);
                                             }
       | Name error exp                     {
                                                 yyerrok; yyclearin; 
              					 nodeInfo* nodeLine = new nodeInfo(scanner.lineno());
                                                 Node* details = new nodeDetails(nodeLine, 0);
                                                 Node* message = new Node;
                                                 message->setval("ERROR <missing EQUALS sign> ");
                                                 Node* nodeErrorMessage = new Node(message, details);
                                                 
                                                 nodeVec.push_back(nodeErrorMessage);
                                                 Node* name = new Node($1, $3);
                                                 name->setval("<Statement>--> <Name> error <exp>\n");
                                                 $$ = new Node(name);
                                                }
         | Name LPAREN Arglist RPAREN SEMI   {
                              Node* temp = new Node($1, $2);
                              Node* temp2 = new Node(temp, $3);
                              Node* temp3 = new Node(temp2, $4);
                              Node* name = new Node(temp3, $5);
                              name->setval("<Statement>--> <Name> LPAREN <Arglist> RPAREN SEMI\n");
                              $$ = new Node(name);
                                             }
       | Name error SEMI                     {
                                                 yyerrok; yyclearin; 
              					 nodeInfo* nodeLine = new nodeInfo(scanner.lineno());
                                                 Node* details = new nodeDetails(nodeLine, 0);
                                                 Node* message = new Node;
                                                 message->setval("ERROR <Arglist error> ");
                                                 Node* nodeErrorMessage = new Node(message, details);
                                                 
                                                 nodeVec.push_back(nodeErrorMessage);
                                                 Node* name = new Node($1, $3);
                                                 name->setval("<Statement>--> <Name> error SEMI\n");
                                                 $$ = new Node(name);
                                                }
         | Name LPAREN RPAREN SEMI           {
                              Node* temp = new Node($1, $2);
                              Node* temp2 = new Node(temp, $3);
                              Node* name = new Node(temp2, $4);
                              name->setval("<Statement>--> <Name> LPAREN RPAREN SEMI\n");
                              $$ = new Node(name);
                                             }
         | PRINT LPAREN Arglist RPAREN SEMI  {
                              Node* temp = new Node($1, $2);
                              Node* temp2 = new Node(temp, $3);
                              Node* temp3 = new Node(temp2, $4);
                              Node* name = new Node(temp3, $5);
                              name->setval("<Statement>--> PRINT LPAREN <Arglist> RPAREN SEMI\n");
                              $$ = new Node(name);
                                             }
         | PRINT LPAREN RPAREN SEMI          {
                              Node* temp = new Node($1, $2);
                              Node* temp2 = new Node(temp, $3);
                              Node* name = new Node(temp2, $4);
                              name->setval("<Statement>--> PRINT LPAREN RPAREN SEMI\n");
                              $$ = new Node(name);
                                             }
         | ConditionalStatement              {
                          Node* name = new Node($1);
                          name->setval("<Statement>--> <ConditionalStatement>\n");
                          $$ = new Node(name);
                                             }
         | WHILE LPAREN exp RPAREN Statement {
                              Node* temp = new Node($1, $2);
                              Node* temp2 = new Node(temp, $3);
                              Node* temp3 = new Node(temp2, $4);
                              Node* name = new Node(temp3, $5);
                              name->setval("<Statement>--> WHILE LPAREN <exp> RPAREN <Statement>\n");
                              $$ = new Node(name);
                                             }
         | RETURN OptionalExpression SEMI    {
                              Node* temp = new Node($1, $2);
                              Node* name = new Node(temp, $3);
                              name->setval("<Statement>--> RETURN <OptionalExpression> SEMI\n");
                              $$ = new Node(name);
                                             }
         | RETURN SEMI                       {
                          Node* name = new Node($1, $2);
                          name->setval("<Statement>--> RETURN SEMI\n");
                          $$ = new Node(name);
                                             }
         | Block         {
                          Node* name = new Node($1);
                          name->setval("<Statement>--> <Block>\n");
                          $$ = new Node(name);
                         }
;
VarDeclaration:   Type IDENTIFIER SEMI                    {
	                                                  //  $1->setval(" <Type>\n");
                                                            Node* temp = new Node($1, $2); 
                                                            Node* name = new Node(temp, $3);
                                                            name->setval("<VarDeclaration>--> <Type> IDENTIFIER SEMI\n");
                                                            $$ = new Node(name);	
                                                            }
               | IDENTIFIER IDENTIFIER SEMI               {
                                                          //  $$ = new nodeVarDec($1,$2);
                                                          //  $$->setval(" ");
                                                            Node* temp = new Node($1, $2); 
                                                            Node* name = new Node(temp, $3);
                                                            name->setval("<VarDeclaration>--> IDENTIFIER IDENTIFIER SEMI\n");
                                                            $$ = new Node(name);	
                                                            }
                | IDENTIFIER MultiBrackets IDENTIFIER SEMI {
                                                            Node* temp = new Node($1, $2); 
                                                            Node* temp2 = new Node(temp, $3);
                                                            Node* name = new Node(temp2, $4);
                                                            name->setval("<VarDeclaration>-->IDENTIFIER <MultiBrackets> IDENTIFIER SEMI\n");
                                                            $$ = new Node(name);	
                                                            }
/*
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

MultiBrackets: BRACKETS               { 
                          Node* name = new Node($1);
                          name->setval("<MultiBrackets>--> BRACKETS\n");
                          $$ = new Node(name);
	                              }
	     | MultiBrackets BRACKETS {
                                       Node* name = new Node($1, $2);
                                       name->setval("<MultiBrackets>--> <MultiBrackets> BRACKETS\n");
                                       $$ = new Node(name);
                                      }
;

Type:   SimpleType 	{
		         // $1->setval(" <SimpleType>\n");
                          Node* name = new Node($1);
                          name->setval("<Type>--><SimpleType>\n");
                          $$ = new Node(name);
                        }
       | Type LBR RBR    { 
                          //$1->setval(" <Type>\n");
                          Node* temp = new Node($1, $2);
                          Node* name = new Node(temp, $3);
                          name->setval("<Type>--><Type> BRACKETS\n");
                          $$ = new Node(name); 
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
SimpleType: INT          {
                          Node* name = new Node($1);
                          name->setval("<SimpleType>--> INT\n");
                          $$ = new Node(name);
	                 }
;
Name:   THIS 		{ 
                          Node* name = new Node($1);
                          name->setval("<Name>--> THIS\n");
                          $$ = new Node(name);
                        }
       | IDENTIFIER    { 
                          Node* name = new Node($1); 
                          name->setval("<Name>--> IDENTIFIER\n");
                          $$ = new Node(name);
                        }
       | Name DOT IDENTIFIER  { 
                          Node* name = new Node($1, $3);
                          name->setval("<Name>--> <Name> DOT IDENTIFIER\n");
                          $$ = new Node(name);
                        }
       | Name LBR exp RBR   { 
                          Node* name = new Node($1, $3);
                          name->setval("<Name>--> <Name> LBRACKET <exp> RBRACKET\n");
                          $$ = new Node(name);
                        }
;

Arglist: exp              {
                          Node* name = new Node($1);
                          name->setval("<Arglist>--> <exp>\n");
                          $$ = new Node(name);
                          }
       | Arglist COMMA exp                            {
                                                       Node* temp = new Node($1, $2);
                                                       Node* name = new Node(temp, $3);                                                                         
                                                       name->setval("<Arglist>--> <Arglist> COMMA <exp>\n");
                                                       $$ = new Node(name);
                                                      }
       ;
ConditionalStatement: IF LPAREN exp RPAREN Statement {
                              Node* temp = new Node($1, $2);
                              Node* temp2 = new Node(temp, $3);
                              Node* temp3 = new Node(temp2, $4);
                              Node* name = new Node(temp3, $5);
                              name->setval("<ConditionalStatement>--> IF LPAREN <exp> RPAREN <Statement>\n");
                              $$ = new Node(name);
                                                     }
		    | IF LPAREN exp RPAREN Statement ELSE Statement 
                            {
                              Node* temp = new Node($1, $2);
                              Node* temp2 = new Node(temp, $3);
                              Node* temp3 = new Node(temp2, $4);
                              Node* temp4 = new Node(temp3, $5);
                              Node* temp5 = new Node(temp4, $6);
                              Node* name = new Node(temp5, $7);
                              name->setval("<ConditionalStatement>--> IF LPAREN <exp> RPAREN <Statement> ELSE <Statement>\n");
                              $$ = new Node(name);
                             }
                    ;
OptionalExpression: exp {
                          Node* name = new Node($1);
                          name->setval("<OptionalExpression>--> <exp>\n");
                          $$ = new Node(name);
		        }
		  ;
exp:  Name 		{
                          Node* name = new Node($1);
                          name->setval("<exp>--> <Name>\n");
                          $$ = new Node(name);
                        }
       | INTEGER 	{ 
                          Node* name = new Node($1);
                          name->setval("<exp>--> INTEGER\n");
                          $$ = new Node(name);
                        }
       | NLL     	{ 
                          Node* name = new Node($1);
                          name->setval("<exp>--> NULL\n");
                          $$ = new Node(name);
                        }
       | Name LPAREN Arglist RPAREN {
                              Node* temp = new Node($1, $2);
                              Node* temp2 = new Node(temp, $3);
                              Node* name = new Node(temp2, $4);
                              name->setval("<exp>--> <Name> LPAREN <Arglist> RPAREN\n");
                              $$ = new Node(name);
                                    }
       | Name LPAREN RPAREN         {
                              Node* temp = new Node($1, $2);
                              Node* name = new Node(temp, $3);
                              name->setval("<exp>--> <Name> LPAREN RPAREN\n");
                              $$ = new Node(name);
                                    }
       | READ LPAREN RPAREN  	{ 
                          Node* temp = new Node($1, $2);
                          Node* name = new Node(temp, $3);
                          name->setval("<exp>--> READ PARENTHESIS\n");
                          $$ = new Node(name);
                         // $1->setval("read()");
                         // $$ = $1;	
                        }
       | NewExpression 	{ 
                          Node* name = new Node($1);
                          name->setval("<exp>--> <NewExpression>\n");
                          $$ = new Node(name);
                         // $$ = $1;	
                        }
       | PLUS exp %prec POS    { 
                          Node* name = new Node($1, $2);
                          name->setval("<exp>--> PLUS <exp>\n");
                          $$ = new Node(name);
                        //  Node* plus = new nodePlus($2, 0);
                        //  $$ = new Node($$, plus);
                        //  $$ = plus;
                        }
       | MINUS exp %prec NEG  { 
                          Node* name = new Node($1, $2);
                          name->setval("<exp>--> MINUS <exp>\n");
                          $$ = new Node(name);
                         // Node* minus = new nodeMinus($2, 0);
                         // $$ = new Node($$, minus);
                         //  $$ = minus;
                        }
       | NOT exp %prec NOTTY    {
                          Node* name = new Node($1, $2);
                          name->setval("<exp>--> NOT <exp>\n");
                          $$ = new Node(name);
                         // Node* nt = new nodeNot($2, 0);
                        //  $$ = new Node($$, nt);
                        //    $$ = nt;
                        }
       | exp COMPARE_EQUAL exp     { 
                              Node* temp = new Node($1, $2);
                              Node* name = new Node(temp, $3);
                              name->setval("<exp>--> <exp> COMPARE_EQUAL <exp>\n");
                              $$ = new Node(name);
                     //   $$ = new Node($1, $3);
                     //   $$->setval("=="); 
                        }
       | exp COMPARE_NOTEQUAL exp     { 
                              Node* temp = new Node($1, $2);
                              Node* name = new Node(temp, $3);
                              name->setval("<exp>--> <exp> COMPARE_NOTEQUAL <exp>\n");
                              $$ = new Node(name);
                      //  $$ = new Node($1, $3);
                      //  $$->setval("!="); 
                        }
       | exp LESSOREQUAL exp     { 
                              Node* temp = new Node($1, $2);
                              Node* name = new Node(temp, $3);
                              name->setval("<exp>--> <exp> LESS_OR_EQUAL <exp>\n");
                              $$ = new Node(name);
                      //  $$ = new Node($1, $3);
                      //  $$->setval("<="); 
                        }
       | exp GREATEROREQUAL exp     { 
                              Node* temp = new Node($1, $2);
                              Node* name = new Node(temp, $3);
                              name->setval("<exp>--> <exp> GREATER_OR_EQUAL <exp>\n");
                              $$ = new Node(name);
                      //  $$ = new Node($1, $3);
                      //  $$->setval(">="); 
                        }
       | exp LESSTHAN exp     { 
                              Node* temp = new Node($1, $2);
                              Node* name = new Node(temp, $3);
                              name->setval("<exp>--> <exp> LESS_THAN <exp>\n");
                              $$ = new Node(name);
                        //$$ = new Node($1, $3);
                        //$$->setval("<"); 
                        }
       | exp GREATERTHAN exp     { 
                              Node* temp = new Node($1, $2);
                              Node* name = new Node(temp, $3);
                              name->setval("<exp>--> <exp> GREATER_THAN <exp>\n");
                              $$ = new Node(name);
                        //$$ = new Node($1, $3);
                        //$$->setval(">"); 
                        }
       | exp PLUS exp     { 
                              Node* temp = new Node($1, $2);
                              Node* name = new Node(temp, $3);
                              name->setval("<exp>--> <exp> PLUS <exp>\n");
                              $$ = new Node(name);
                       // $$ = new Node($1, $3);
                       // $$->setval("+");
                         } 
       | exp MINUS exp     { 
                              Node* temp = new Node($1, $2);
                              Node* name = new Node(temp, $3);
                              name->setval("<exp>--> <exp> <MINUS> <exp>\n");
                              $$ = new Node(name);
                       // $$ = new Node($1, $3);
                       // $$->setval("-"); 
                        }
       | exp COMPARE_OR exp     { 
                              Node* temp = new Node($1, $2);
                              Node* name = new Node(temp, $3);
                              name->setval("<exp>--> <exp> OR <exp>\n");
                              $$ = new Node(name);
                       // $$ = new Node($1, $3);
                       // $$->setval("||"); 
                        }
       | exp DIV exp     { 
                              Node* temp = new Node($1, $2);
                              Node* name = new Node(temp, $3);
                              name->setval("<exp>--> <exp> DIV <exp>\n");
                              $$ = new Node(name);
                       // $$ = new Node($1, $3);
                       // $$->setval("/"); 
                        }
       | exp TIMES exp     { 
                              Node* temp = new Node($1, $2);
                              Node* name = new Node(temp, $3);
                              name->setval("<exp>--> <exp> TIMES <exp>\n");
                              $$ = new Node(name);
                       // $$ = new Node($1, $3);
                       // $$->setval("*"); 
                        }
       | exp MOD exp     { 
                              Node* temp = new Node($1, $2);
                              Node* name = new Node(temp, $3);
                              name->setval("<exp>--> <exp> MOD <exp>\n");
                              $$ = new Node(name);
                       // $$ = new Node($1, $3);
                       // $$->setval("%"); 
                        }
       | exp COMPARE_AND exp     { 
                              Node* temp = new Node($1, $2);
                              Node* name = new Node(temp, $3);
                              name->setval("<exp>--> <exp> AND <exp>\n");
                              $$ = new Node(name);
                       // $$ = new Node($1, $3);
                       // $$->setval("&&"); 
                        }
       | LPAREN exp RPAREN    { 
                              Node* temp = new Node($1, $2);
                              Node* name = new Node(temp, $3);
                              name->setval("<exp>--> LPAREN <exp> RPAREN\n");
                              $$ = new Node(name);
                       //  $$ = new nodeParExp($2);	
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
NewExpression: NEW IDENTIFIER LPAREN RPAREN {
                              Node* temp = new Node($1, $2);
                              Node* temp2 = new Node(temp, $3);
                              Node* name = new Node(temp2, $4);
                              name->setval("<NewExpression>--> NEW IDENTIFIER LPAREN RPAREN\n");
                              $$ = new Node(name);
                             }
             | NEW IDENTIFIER LPAREN Arglist RPAREN {
                              Node* temp = new Node($1, $2);
                              Node* temp2 = new Node(temp, $3);
                              Node* temp3 = new Node(temp2, $4);
                              Node* name = new Node(temp3, $5);
                              name->setval("<NewExpression>--> NEW IDENTIFIER LPAREN <Arglist> RPAREN\n");
                              $$ = new Node(name);
                             }
	       | NEW SimpleType{ 
                                    Node* name = new Node($1, $2);
                                    name->setval("<NewExpression>--> NEW <SimpleType>");
                                    $$ = new Node(name);	
                                    }
               | NEW SimpleType MultiArrays              {
                                                         
                                                         Node* expNode = new Node($1, $2);
                                                         Node* name = new Node(expNode, $3);
                                                         name->setval("<NewExpression>--> NEW <SimpleType> <MultiArrays>\n");
                                                         $$ = new Node(name);
                                                         }
               | NEW SimpleType MultiBrackets            {
                                                         Node* expNode = new Node($1, $2);
                                                         Node* name = new Node(expNode, $3);
                                                         name->setval("<NewExpression>--> NEW <SimpleType> <MultiBrackets>\n");
                                                         $$ = new Node(name);
                                                         }
               | NEW SimpleType MultiArrays MultiBrackets {
                                                         Node* expNode = new Node($1, $2);
                                                         Node* expNode2 = new Node(expNode, $3);
                                                         Node* name = new Node(expNode2, $4);
                                                         name->setval("<NewExpression>--> NEW <SimpleType> <MultiArrays> <MultiBrackets>\n");
                                                         $$ = new Node(name);
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
	                            Node* temp = new Node($1, $2);
	                            Node* name = new Node(temp, $3);
                                    name->setval("<MultiArrays>--> LBRACKET <exp> RBRACKET\n");
                                    $$ = new Node(name);
                                    }
	  | MultiArrays LBR exp RBR 
                                    {
	                            Node* temp = new Node($1, $2);
	                            Node* temp2 = new Node(temp, $3);
                                    Node* name = new Node(temp2, $4);
                                    name->setval("<MultiArrays>--> <MultiArrays> LBRACKET <exp> RBRACKET\n");
                                    $$ = new Node(name);
                                    }
; 
%%
