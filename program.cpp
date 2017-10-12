/*program2.cpp
Dylan Brigham
COSC 4785
9/24/17
*/

#include <stdlib.h>
#include<FlexLexer.h>
#include<iostream>
#include "program.h"
#include <iomanip>
#include <vector>

int Token::_column = 1;

int main()
{
  yyFlexLexer myScanner;
  int rtn;
  int previousLine;
  Token token;
  std::vector<Token> errorCatalog;

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

	 /*if an error, store error and exit program if errors greater than 20*/
	     if(rtn == 9)	       {
	         const Token error = token;
	         errorCatalog.push_back(error);
		 if(errorCatalog.size() > 20)
		 {
		   std::cout << "Too Many Errors!" << std::endl;
		   std::cout << "Ending Program..." << std::endl;
		   exit(0);
		 }
	       }

	     /*if not comment then print!*/
	     if(rtn!=11)
	     {
               token.print();
	     }

             token.setColumn(myScanner.YYLeng());
	     token.setLine(myScanner.lineno());
	      
             /*if token matches a newline then reset column to 1*/
	     if(rtn ==8)
	       {
	         token.resetColumn();
	       }
	     token.clear();
           }

      return 0;
}                    
