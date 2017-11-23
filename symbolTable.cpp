#include "symbolTable.h"
#include "scope.h"
using namespace std;


SymbolTable::SymbolTable(SymbolTable* parent) 
       {
        //create an empty symbol table takes a pointer to parent table
        //indicate if creation was successful
        _parent = parent;
       }
SymbolTable::~SymbolTable()
       {
       }
int SymbolTable::insert(string name, Scope* typeInfo)
       {
       //check first that is aleady declared in local scope return error if yes
       //else, return value indicating success
         return ( _table.insert({name, typeInfo}).second);
       }
Scope* SymbolTable::lookup(string symbol)
       {
       //determine if the identifier has been declared in the current scope
       //if yes, return a value that can validate type
       //if no, return -1
       if(this->_parent == 0 && _table.count(symbol) == 0)
         return 0;
     //  if(_table.count(symbol) == 0)
     //    return 0;
       if(_table.count(symbol) > 0)
         return _table[symbol];
       return (this->_parent)->lookup(symbol);
       //returns the Scope datastructure that hold data information
    //   return _table[symbol];
       }
void SymbolTable::dump(string indent)
       {
         
         for(auto it = _table.begin(); it != _table.end(); it++)
         {
           cout << indent << it->first << " ";
          // cout << indent;
           Scope* data = it->second;
           for(int i = 0; i < 5 ; i++)
           {
               if(data->_dataInfo[i] != "@")
                 cout <<data -> _dataInfo[i]<< " ";
           }
           cout << endl;
           if(data->_child != 0)
           {
             (data->_child)->dump(indent + "  ");
           } 
         }
       }

