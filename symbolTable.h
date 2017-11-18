/*Dylan Brigham
  SymbolTable.h
*/
#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <unordered_map>
#include <string>
#include "scope.h"
using namespace std;


class SymbolTable
{
private:
        SymbolTable* _parent;
        unordered_map<string, Scope*> _table;
public:
       SymbolTable(SymbolTable* parent = 0) 
       {
        //create an empty symbol table takes a pointer to parent table
        //indicate if creation was successful
        _parent = parent;
       }
       ~SymbolTable()
       {
       }
       int insert(string name, Scope* typeInfo)
       {
       //check first that is aleady declared in local scope return error if yes
       //else, return value indicating success
         if( _table.insert({name, typeInfo}).second)
           {
             typeInfo->_ptrToParent = _parent;
             return 1;
           }
         return 0;
       }
       Scope* lookup(string symbol)
       {
       //determine if the identifier has been declared in the current scope
       //if yes, return a value that can validate type
       //if no, return -1
       if(_table.count(symbol) == 0)
         return 0;
       //returns the Scope datastructure that hold data information
       return _table[symbol];
       }

    void dump()
    {
     if(_parent == 0) 
     {
       for( auto it = _table.begin(); it != _table.end(); it++)
       {
         cout << it->first << (it->second)-> _dataType <<  (it->second)-> _kind;
       }
     }
    }
};

#endif
