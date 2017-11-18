#ifndef SCOPE_H
#define SCOPE_H

#include "symbolTable.h"
#include <string>
using namespace std;
class SymbolTable;

struct Scope
{
  int  _dataType;
  string _kind;
  SymbolTable* _ptrToParent;
};

#endif
