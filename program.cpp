/*program.cpp
Dylan Brigham
COSC 4785
10-20-2017
HMK03
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
      cerr << "Parse tree could not be build.." << endl;
    cout << endl;
  //  cout << buffer.size() << endl;
   // for(unsigned int i = 0; i < buffer.size(); i++)
   //   cout << buffer.at(i);
//    table = generateSymbolTable(buffer);
    table->dump("");
    cout << endl;
    return 0;
}                    

/*
SymbolTable* generateSymbolTable(vector<string> buffer)
{
  SymbolTable* global = new SymbolTable(0);
  for(unsigned int i = 0; i < buffer.size(); i++)
  {
    while(buffer.at(i) == "Class_Type")
    {
      cout<<endl;
      Scope* info = new Scope;
      info->_dataInfo[0] = buffer.at(i);
    cout << buffer.at(i) << " overall_type"<< endl;
   //   info->_dataInfo[1] = buffer.at(++i);
      ++i;
    cout << buffer.at(i) << " datatype" << endl;
      string name = buffer.at(++i);
      
   cout << buffer.at(i) << " name" << endl;
      SymbolTable* local1 = new SymbolTable(global);
      info->_child = local1;
      global->insert(name, info);
      i+=3;
      while(buffer.at(i) == "VarDec_Type")
      {
    cout << buffer.at(i) << " overall_type" << endl;
        Scope* varInfo = new Scope;
      //  varInfo->_dataInfo[0] = buffer.at(i);
        varInfo->_dataInfo[1] = buffer.at(++i);
    cout << buffer.at(i) << " dataType" << endl;
        ++i;
        while(buffer.at(i) == "[")
        {
          i+=2;
        }
        string varName = buffer.at(i);
    cout << buffer.at(i) << " varName" << endl;
        varInfo->_child = 0;
        if(buffer.at(++i) == ";")
        {
          local1->insert(varName, varInfo); 
        }
       ++i;
      }
      while(buffer.at(i) == "Constructor_Type")
        {
        cout << buffer.at(i) << " overall_type" << endl;
        Scope* consInfo = new Scope;
        consInfo->_dataInfo[0] = buffer.at(i);
    //    consInfo->_dataInfo[1] = buffer.at(++i);
   cout << buffer.at(i) << " dataType" << endl;
        string consName = buffer.at(++i);
        ++i;
        ++i;
        int counter = 0;
        string paramList;
        while(buffer.at(i) != ")")
          {
          if(counter == 0)
            consInfo->_dataInfo[2] = buffer.at(i);
          else
            consInfo->_dataInfo[2] = consInfo->_dataInfo[2] + "x" + buffer.at(i);
          ++counter;
          i+=2;
          }
        ++i;
        ++i;
        ++i;
        SymbolTable* local2 = new SymbolTable(local1);
        consInfo->_child = local2;
        local1->insert(consName, consInfo);
    cout << buffer.at(i) << endl;
        while(buffer.at(i) == "VarDec_Type")
        {
   cout << buffer.at(i) << " overall_type" << endl;
          Scope* lVarInfo = new Scope;
      //  varInfo->_dataInfo[0] = buffer.at(i);
          lVarInfo->_dataInfo[1] = buffer.at(++i);
     cout << buffer.at(i) << " dataType" << endl;
          string lVarName= buffer.at(++i);
     cout << buffer.at(i) << " lVarName" << endl;
          lVarInfo->_child = 0;
          if(buffer.at(++i) == ";")
          {
            local2->insert(lVarName, lVarInfo); 
          }
         ++i;
	cout << buffer.at(i) << endl;
        }
       while(buffer.at(i) == "Statement_Type1"||buffer.at(i) == "Statement_Type2"||buffer.at(i) == "Statement_Type3"
	   ||buffer.at(i) == "Statement_Type4"||buffer.at(i) == "Statement_Type5"||buffer.at(i) == "Statement_Type6"
	   ||buffer.at(i) == "Statement_Type7"||buffer.at(i) == "Statement_Type8"||buffer.at(i) == "Statement_Type9")
         {
         if( buffer.at(i) == "Statement_Type1")
	 {
           //ignore
	 }
         if( buffer.at(i) == "Statement_Type2")
	 {
	 }
         if( buffer.at(i) == "Statement_Type3")
	 {

	 }
         if( buffer.at(i) == "Statement_Type4")
	 {

	 }
         if( buffer.at(i) == "Statement_Type5")
	 {

	 }
         if( buffer.at(i) == "Statement_Type6")
	 {

	 }
         if( buffer.at(i) == "Statement_Type7")
	 {

	 }
         if( buffer.at(i) == "Statement_Type8")
	 {

	 }
         if( buffer.at(i) == "Statement_Type9")
	 {

	 }
	 ++i;
         }
      }
    }
  }

  return global;
}
*/
