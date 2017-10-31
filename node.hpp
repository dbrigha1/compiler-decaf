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

using std::string;
using std::endl;
using std::ostream;

extern unsigned int column;
extern yyFlexLexer scanner;

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
