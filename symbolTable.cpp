#include <iostream>
#include "symbolTable.h"
#include <string>
using namespace std;
int main() 
{
  string sample = "class";

  SymbolTable global = new SymbolTable(0);
  Scope* sGlobal = new Scope;
  sGlobal-> _dataType = 3;
  sGlobal-> _kind = "class_type";
  
  int result = global.insert("name", sGlobal);
  cout << result << endl;
  cout << global.insert("name", sGlobal) << endl;

  Scope* classInfo = global.lookup("name");

    
  return 0;
}
