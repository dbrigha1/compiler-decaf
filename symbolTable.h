/*Dylan Brigham
  SymbolTable.h
  Compilers
  11/23/2017
*/
#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <unordered_map>
#include <string>
#include <iostream>
#include "scope.h"

using namespace std;
class Scope;

class SymbolTable
{
public:
        SymbolTable* _parent;
        unordered_map<string, Scope*> _table;
public:
       SymbolTable(SymbolTable* parent = 0); 
       ~SymbolTable();
       int insert(string name, Scope* typeInfo);
       Scope* lookup(string symbol);
       void dump(string indent);

};

#endif
