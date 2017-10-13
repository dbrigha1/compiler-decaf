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
      if(left) left->print(out);
      *out << sval ;
      if(right) right->print(out);
      //*out << endl;
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
      *out << "( ";
      if(left) left->print(out);
      if(right) right->print(out);
      *out << " )" ;//<< endl;
      return;
    }
};


#endif
