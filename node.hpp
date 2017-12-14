/*
 * This defines the "node" class in C++. Do not need this for C because 
 * just use the standard flex "yyxxxxx" variables/functions. 
 * The commented out portions are for debugging.
 *
 *
 *
 * $Author: kbuckner $
 * $Id: node.hpp,v 1.1 2017-10-04 13:20:53-06 kbuckner Exp kbuckner $
 * $Date: 2017-10-04 13:20:53-06 $
 *
 * $Log: node.hpp,v $
 * Revision 1.1  2017-10-04 13:20:53-06  kbuckner
 * Finally working version
 *
 *
 *
 */

#ifndef NODE_HPP
#define NODE_HPP
#include<iostream>
#include<string>
#include<vector>
#include "scope.h"

using std::string;
using std::endl;
using std::ostream;

extern unsigned int column;
extern yyFlexLexer scanner;
extern int numMains;

class Node
{
  public:
    // set the pointers to 0 C++ is trying to get away from NULL
    Node(Node *lf=0,Node *rt=0) 
    {
      reset();
      dval=0.0;
      ival=0;
      left=lf;
      right=rt; 
    }
    virtual ~Node()
    {
      if(left) delete left;
      if(right) delete right;
    }
    int getint() const
    {
      return ival;
    }
    double getdbl() const
    {
      return dval;
    }
    string getstring() const
    {
      return sval;
    }
    void setval(const char *v)
    {
      sval=v;
    }
    void setval(const string s)
    {
      sval=s;
    }
    void setval(int i)
    {
      ival=i;
    }
    void setval(double d)
    {
      dval=d;
    }

    void reset() {
      yyline=yycol=nextline=nextcol=1;
      sval.clear();
    }

    void setleft(Node *p) 
    {
      left=p;
      return;
    }
    void setright(Node *p) 
    {
      right=p;
      return;
    }
    Node* getleft()
    {
      return left;
    }
    Node* getright()
    {
      return right;
    }

    virtual void print(ostream *out = 0)
    {
      *out << sval;
      if(left) left->print(out);
      if(right) right->print(out);
      return;
    }
/*    void getParseTree(vector<string> &buffer)
    {
      if(sval != "")
        buffer.push_back(sval);
      if(left) left->getParseTree(buffer);
      if(right) right->getParseTree(buffer);
      return;
    }
    *//*
    void getParseTree(SymbolTable*& table, vector<string>& collection, string& previous, string& hold)
    {
      if(sval == "{")
      {
        SymbolTable* child = new SymbolTable(table);
        Scope* info = new Scope;
        for(unsigned int i = 0; i < collection.size(); i++)
        {
          info->_dataInfo[i] = collection[i];
        }
        collection.clear();
        info->_child = child;
        table->insert(info->_dataInfo[2], info);
        table = child;
      }
      if(sval == ")")
      {
        Scope* info = new Scope;
        for(unsigned int i = 0; i < collection.size()-2; i++)
        {
          info->_dataInfo[i] = collection[i];
        }
        if(previous != "(")
        {
        if(hold != "")
          info->_dataInfo[collection.size()-2] = hold + "X" + collection[collection.size()-2];
        else
          info->_dataInfo[collection.size()-2] = collection[collection.size()-2];
        }
        hold = "";
        collection.clear();
        table->insert(info->_dataInfo[2], info);
        
      }
      if(sval == ",")
      {
        if(hold == "")
          hold = collection[collection.size()-2];
        else
          hold = hold + "X" + collection[collection.size()-2];
        for(int i = 0; i<2; i++)
        {
          collection.pop_back();
        }
      }
      if(sval == ";")
      {
        Scope* info = new Scope;
        for(unsigned int i = 0; i < collection.size(); i++)
        {
          info->_dataInfo[i] = collection[i];
        }
        collection.clear();
        table->insert(info->_dataInfo[2], info);
      }
      if(sval == "}")
      {
        table = table->_parent;
      }
      if(sval != "[" && sval != "]" && sval != "," && sval != "(" && sval != ")" && sval!= ";" && sval != ""&& sval != "}" && sval != "{")
      {
        collection.push_back(sval);
        previous = sval;
          
      }
        if(left) left->getParseTree(table, collection, previous, hold);
        if(right) right->getParseTree(table, collection, previous, hold); 
      return;
      
    }*/

    void getParseTree(SymbolTable*& table, vector<string>& collection, string& previous, string& hold, string& type, int& counter, string& arglist, bool& trigger, string& name)
    {
        
      if(sval != "")
      {
        /*
         if(previous == "varType@")
         {
          Scope* check =  table->lookup(sval);
          if(check == 0)
          {
              cout << "ERROR <Out of Scope>" << endl;
          }
         }
         */
         if(previous == "VarDec_Type@")
         {
          Scope* check =  table->lookup(sval);
          if(check == 0)
          {
              cout << "ERROR <Out of Scope>" << endl;
          }
         }
        if(previous == "whileType@")
        {
          collection[0] = "While_Type";
        }
        if(previous == "resultType@")
          {
            collection[1] = sval;
            hold = sval;
          }
        if(previous == "param@")
        {
          if(collection[4] != "@")   //changed all 3s to 4s
            collection[4] = collection[4] + "X" + sval;
          else
            collection[4] = sval;
        }/*
        if(previous == "paramName@")
        {
          if(collection[4] != "@")   //changed all 3s to 4s
            collection[4] = collection[4] + "X" + sval;
          else
            collection[4] = sval;
        }*/
        if(previous == "kind@")
        {
          collection[2] = sval;
        }
        if(previous == "type@")
        {
          collection[1] = sval;
        }
        if(previous == "ident@")
        {
          collection[0] = sval;
        }
        if(previous == "consIdent@")
        {
             string symbol;
             string resultType;
             SymbolTable* currentLocation = table;
             SymbolTable* parentLocation = table->_parent;
             for(auto it = parentLocation->_table.begin(); it != parentLocation->_table.end(); it++)
             {
               if((it->second)->_child == currentLocation)
               {
                 symbol = it->second->_dataInfo[0];
        //         resultType = it->second->_dataInfo[1];
                 break;
               }
             }
             Scope* typeCheck = table->lookup(symbol);
         //   cout << typeCheck->_dataInfo[1] << endl;
             if(typeCheck != 0)
             {
               if(typeCheck->_dataInfo[0] != sval)
          //       if(resultType != type)
                   cout << "ERROR <'" << sval << "' invalid constructor>" << endl;
             }

          collection[0] = sval;
        }
        if(sval == ";")
        {
          Scope* info = new Scope;
          for(unsigned int i = 0; i < collection.size(); i++)
          {
            if(hold != "" && i == 3)
              info->_dataInfo[i] = hold + "<-";  //removed collection[i]
            else
              info->_dataInfo[i] = collection[i];
            collection[i] = "@";
          }
          hold = "";
         // collection.clear();
          if(info->_dataInfo[0] != "@")
          {
            
            int result = table->insert(info->_dataInfo[0], info);
            if(result == 0)
            {
              cout << "ERROR " << " <'" << info->_dataInfo[0] << "' " << "already declared in scope>" << endl;
            }
          }
        }
        if(sval == "}")
        {
          table = table->_parent;
        }
        if(sval == "{")
        {
          SymbolTable* child = new SymbolTable(table);
          Scope* info = new Scope;
          for(unsigned int i = 0; i < collection.size(); i++)
          {
            if(hold != "" && i == 3 && collection[i+1] != "@")
              info->_dataInfo[i] = hold + " <- "; //removed collection[i]
            else if(hold != "" && i == 3 && collection[i+1] == "@")
              info->_dataInfo[i] = hold + " <- " + "void";    
            else
              info->_dataInfo[i] = collection[i];
            collection[i] = "@";
          } 
          hold = "";
         // collection.clear();
          info->_child = child;
          if(info->_dataInfo[0] == "While_Type")
          {
            info->_dataInfo[0] = "While_Type" + to_string(counter);
            counter++;
          }  
          table->insert(info->_dataInfo[0], info);
          type = "void"; 
          table = child;
        }
        type = this->checkParseTree(sval, table, previous, type, arglist, trigger, name);
        previous = sval;
      }
        if(left) left->getParseTree(table, collection, previous, hold, type, counter, arglist, trigger, name);
        if(right) right->getParseTree(table, collection, previous, hold, type, counter, arglist, trigger, name); 
      return;
      
    }
    string checkParseTree(string curr, SymbolTable* table, string previous, string type, string& arglist, bool& trigger, string& name)
    {
       if(curr != "")
       {
       //  cout << curr << endl;
        // cout << curr << endl;
         if(previous == "startArgList@")
         {
           trigger = true;
         }
         if(curr == "methodName@")
         {
           name = previous;
         }
         if(curr == "=")
         {
           if(previous == "numType@")
             cout << "ERROR <Invalid left value>" << endl;
           else
           {
             Scope* typeCheck = table->lookup(previous);
             if(typeCheck != 0)
               type = typeCheck->_dataInfo[1];
           }
         }
         if(curr == "argType@" && trigger)
         {
             Scope* typeCheck = table->lookup(previous);
             if(typeCheck != 0)
             {
               if(arglist == "")
                arglist = typeCheck->_dataInfo[1];
               else
                 arglist = arglist + "X" + typeCheck->_dataInfo[1];
             }
           //  cout << arglist << endl;

         }
         if(previous == "varType@" && type == "void" && !trigger)
         {
             Scope* typeCheck = table->lookup(curr);
             if(typeCheck != 0)
             {
               type = typeCheck->_dataInfo[1];
               previous = "done";
             }
             else
             {
               cout << "ERROR <'" << curr << "' declaration error>" << endl;
             }

         }
         if(previous == "intType@" && type == "void")
         {
               type = "int";
         }
         if((previous == "varType@" || previous == "intType@") && type != "void" && (!trigger))
         {
           if(previous == "intType@")
           {
             if("int" != type)
               cout << "ERROR <'" << curr << "' invalid data type>" << endl;
           }
           else
           {
             Scope* typeCheck = table->lookup(curr);
             if(typeCheck != 0)
             {
               if(typeCheck->_dataInfo[1] != type)
                 cout << "ERROR <'" << typeCheck->_dataInfo[0] << "' invalid data type>" << endl;
             }
           }
         }
         if(curr == ";")
         {
           if(previous == "voidReturnType@")
           {
             string symbol;
             string resultType;
             SymbolTable* currentLocation = table;
             SymbolTable* parentLocation = table->_parent;
             for(auto it = parentLocation->_table.begin(); it != parentLocation->_table.end(); it++)
             {
               if((it->second)->_child == currentLocation)
               {
                 symbol = it->second->_dataInfo[0];
        //         resultType = it->second->_dataInfo[1];
                 break;
               }
             }
             Scope* typeCheck = table->lookup(symbol);
         //   cout << typeCheck->_dataInfo[1] << endl;
             if(typeCheck != 0)
             {
               if(typeCheck->_dataInfo[1] != "void")
          //       if(resultType != type)
                   cout << "ERROR <'" << typeCheck->_dataInfo[0] << "' invalid return type>" << endl;
             }


           }
           if(previous == "returnType@")
           {
             string symbol;
             string resultType;
             SymbolTable* currentLocation = table;
             SymbolTable* parentLocation = table->_parent;
             for(auto it = parentLocation->_table.begin(); it != parentLocation->_table.end(); it++)
             {
               if((it->second)->_child == currentLocation)
               {
                 symbol = it->second->_dataInfo[0];
        //         resultType = it->second->_dataInfo[1];
                 break;
               }
             }
             Scope* typeCheck = table->lookup(symbol);
             if(typeCheck != 0)
             {
               if(typeCheck->_dataInfo[1] != type)
          //       if(resultType != type)
                   cout << "ERROR <'" << typeCheck->_dataInfo[0] << "' invalid return type>" << endl;
             }

           }
           if(trigger)
           {
             /*
             string symbol;
             SymbolTable* currentLocation = table;
             SymbolTable* parentLocation = table->_parent;
             for(auto it = parentLocation->_table.begin(); it != parentLocation->_table.end(); it++)
             {
               if((it->second)->_child == currentLocation)
               {
                 symbol = it->second->_dataInfo[0];
        //         resultType = it->second->_dataInfo[1];
                 break;
               }
             }
             cout << "check : " << symbol << endl;
             Scope* typeCheck = table->lookup(symbol);

             if(typeCheck != 0)
             {
               if(typeCheck->_dataInfo[4] != arglist)
                   cout << "ERROR <'" << typeCheck->_dataInfo[4] << "' invalid arguments>" << endl;
             }
*/
      //       cout << name << endl;
             Scope* typeCheck = table->lookup(name);

             if(typeCheck != 0)
             {
               if(typeCheck->_dataInfo[4] != arglist)
                   cout << "ERROR <'" << typeCheck->_dataInfo[4] << "' invalid arguments>" << endl;
             }

           }
           name = "";
           arglist = "";
           type = "void";
           trigger = false;
         }
         previous = curr;
       } 
      //  if(left) left->checkParseTree(table, previous, hold);
      //  if(right) right->checkParseTree(table, previous, hold); 
      return type;
      
    }
  protected:
    int yyline;
    int yycol;
    int ival;
    double dval;
    string sval;
    int nextcol;// not needed?
    int nextline;// not needed?
    Node *left,*right;
};

class nodeMinus : public Node
{
  public:
    nodeMinus(Node *lf=0,Node *rt=0):Node(lf,rt){}

    virtual void print(ostream *out = 0)
    {
      if(left) {
        *out << "-";
        left->print(out);
      }
      //*out << endl;
      return;
    }
};
class nodePlus : public Node
{
  public:
    nodePlus(Node *lf=0,Node *rt=0):Node(lf,rt){}

    virtual void print(ostream *out = 0)
    {
      if(left) {
        *out << "+";
        left->print(out);
      }
      //*out << endl;
      return;
    }
};
class nodeNot : public Node
{
  public:
    nodeNot(Node *lf=0,Node *rt=0):Node(lf,rt){}

    virtual void print(ostream *out = 0)
    {
      if(left) {
        *out << "!";
        left->print(out);
      }
      //*out << endl;
      return;
    }
};

class nodeNum : public Node
{
  public:
    nodeNum(int i)
    {
      ival=i;
    };

    virtual void print(ostream *out = 0)
    {
      *out << ival;
      return;
    }
};

class nodeParExp : public Node
{
  public:
    nodeParExp(Node *lf=0,Node *rt=0):Node(lf,rt){}

    virtual void print(ostream *out = 0)
    {
      *out << "(";
      if(left) left->print(out);
      if(right) right->print(out);
      *out << ")" ;//<< endl;
      return;
    }
};

class nodeType : public Node
{
  public:
    nodeType(Node *lf=0,Node *rt=0):Node(lf,rt){}

    virtual void print(ostream *out = 0)
    {
      if(left) left->print(out);
      *out << sval;
      if(right) right->print(out);
      return;
    }
};

class nodeVarDec : public Node
{
  public:
    nodeVarDec(Node *lf=0,Node *rt=0):Node(lf,rt){}

    virtual void print(ostream *out = 0)
    {
      if(left) left->print(out);
      *out << sval;
      if(right) right->print(out);
      *out << ";" ;
      return;
    }
};
class nodeName : public Node
{
  public:
    nodeName(Node *lf=0,Node *rt=0):Node(lf,rt){}

    virtual void print(ostream *out = 0)
    {
      if(left) left->print(out);
      *out << "[";
      if(right) right->print(out);
      *out << "]" ;
      return;
    }
};

class nodeNewExp1 : public Node
{
  public:
    nodeNewExp1(Node *lf=0,Node *rt=0):Node(lf,rt){}

    virtual void print(ostream *out = 0)
    {
      if(left) left->print(out);
      if(right) right->print(out);
      *out << "()";
      return;
    }
};
class nodeNewExp : public Node
{
  public:
    nodeNewExp(Node *lf=0,Node *rt=0):Node(lf,rt){}

    virtual void print(ostream *out = 0)
    {
      *out << "new ";
      if(left) left->print(out);
      *out << "<[";
      if(right) right->print(out);
      *out << "]>* <[]>*";
      return;
    }
};
class nodeArray : public Node
{
  public:
    nodeArray(Node *lf=0,Node *rt=0):Node(lf,rt){}

    virtual void print(ostream *out = 0)
    {
      *out << "[";
      if(left) left->print(out);
      *out << "]";
      return;
    }
};
class nodeError : public Node
{
  public:
    nodeError(Node *lf=0,Node *rt=0):Node(lf,rt){}

    virtual void print(ostream *out = 0)
    {
      *out << "ERROR line: " << scanner.lineno() << " column: " << column;
      if(left) left->print(out);
      if(right) right->print(out);
      return;
    }
};
class nodeDetails : public Node
{
  public:
    nodeDetails(Node *lf=0,Node *rt=0):Node(lf,rt){}

    virtual void print(ostream *out = 0)
    {
      if(left){*out <<"line:"; left->print(out);}
      *out <<" ";
      if(right) {*out <<"column: "; right->print(out);}
      *out << " ";
      return;
    }
};
class nodeInfo : public Node
{
  public:
    nodeInfo (unsigned int i)
    {
      ival=i;
    };

    virtual void print(ostream *out = 0)
    {
      *out << ival;
      return;
    }
};
#endif
