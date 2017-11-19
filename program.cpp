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
using std::cout;
using std::vector;
using std::cerr;
unsigned int column = 0;
yyFlexLexer scanner;
Node *tree;
vector<Node*> nodeVec;

int main()
{
  tree = 0;
  yyFlexLexer myScanner;

//  int rtn;
//  Token token;
//  std::vector<Token> errorCatalog;
/*
  //setting up header row for table
  std::cout << " " << std::setw(10) << std::left << "Line"
            << " " << std::setw(10) << std::left << "Column"
            << " " << std::setw(20) << std::left << "Token"
            << " " << std::setw(20) << std::left << "Value"
  << std::endl;
 
      while((rtn=myScanner.yylex()) != 0) 
           {		 
                token.setType(rtn);
	        token.setValue(rtn);
                token.setLength(myScanner.YYLeng());
	        token.setToken(myScanner.YYText());
	        token.setLine(myScanner.lineno());
	*/
	     /*if an error, store error and exit program if errors greater than 20*//*
	     if(rtn == 9)
      	     {
	        const Token error = token;
	        errorCatalog.push_back(error);
	        if(errorCatalog.size() > 20)
		 {
		   std::cout << "Too Many Errors!" << std::endl;
		   std::cout << "Ending Program..." << std::endl;
		   exit(0);
		 }
	     }

               token.print();
               token.setColumn(myScanner.YYLeng());
	       token.clear();
	   }
     
*/
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
	cout << endl;
	if(tree != 0)
	  tree->print(&cout);
	else
	  cerr << "Parse tree could not be build.." << endl;
	cout << endl;
      return 0;
}                    
