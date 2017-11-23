/*Dylan Brigham
 * Compilers
 * Dr. Buckner
 * 11/23/2017*/

#ifndef SCOPE_H
#define SCOPE_H

#include "symbolTable.h"
#include <string>
using namespace std;
class SymbolTable;

struct Scope
{
  SymbolTable* _child;
  string _dataInfo[5]= {"@"};
};

#endif
