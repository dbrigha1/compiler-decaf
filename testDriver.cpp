#include <iostream>
#include "scope.h"
#include "symbolTable.cpp"
#include <string>
using namespace std;
int main() 
{
  string sample = "class";

  SymbolTable* global = new SymbolTable(0);
  Scope* sGlobal = new Scope;
  sGlobal-> _dataInfo[0] = "int";
  sGlobal-> _dataInfo[1] = "class_type";
  
  int result = global->insert("name", sGlobal);
  cout << result << endl;
  cout << global->insert("name", sGlobal) << endl;

  Scope* classInfo = global->lookup("name");
  cout << classInfo -> _dataInfo[0] << endl;
  cout << classInfo -> _dataInfo[1] << endl;

  SymbolTable* local = new SymbolTable(global);
  Scope* sLocal = new Scope;
  sGlobal->_child = local;
  sLocal-> _dataInfo[0] = "void";
  sLocal-> _dataInfo[1] = "method_type";
  local->insert("new name", sLocal);

  global->dump();
  return 0;
}
