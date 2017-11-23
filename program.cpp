/*program.cpp
Dylan Brigham
COSC 4785
11-23-2017
HMK05
*/

#include <stdlib.h>
#include<FlexLexer.h>
#include<iostream>
//#include "program.h"
#include "node.hpp"
#include "scope.h"
#include "symbolTable.cpp"
#include "program.tab.h"
#include <iomanip>
#include <vector>
#include <string>
using std::cout;
using std::vector;
using std::cerr;
using std::vector;
using std::string;
unsigned int column = 0;
yyFlexLexer scanner;
Node *tree;
vector<Node*> nodeVec;
//SymbolTable* table;
//SymbolTable* generateSymbolTable(vector<string> buffer);


  int main()
  {
    int unique = 1;
    string hold = "";
    string name = "";
    string arglist = "";
    string type = "void";
    bool trigger= false;
    tree = 0;
    SymbolTable* table = new SymbolTable(0);
    string begin = "";
    vector<string> collection(5, "@");
    vector<string> buffer;
    const int errorLimit = 20;
    int counter = 0;
    yyparse();
    while(!nodeVec.empty())
    {
      if(counter > errorLimit)
      {
        cerr << "Too Many Errors!" << endl;
        cerr << "Ending Program..."<< endl;
        exit(0);
      }
      nodeVec.back()->print(&cout);
      nodeVec.pop_back();
      cout << endl;
      counter++;
    }
    if(tree != 0)
    {
     tree->getParseTree(table, collection, begin, hold, type, unique, arglist, trigger, name);
     // tree->print(&cout);
     cout << endl;
    }
    else
      cerr << "Parse tree could not be build.. <possibly need closing brace>" << endl;
    cout << endl;
  //  cout << buffer.size() << endl;
   // for(unsigned int i = 0; i < buffer.size(); i++)
   //   cout << buffer.at(i);
//    table = generateSymbolTable(buffer);
    table->dump("");
    cout << endl;
    return 0;
}                    
