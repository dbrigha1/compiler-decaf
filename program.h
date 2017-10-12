/*program2.h
 *Dylan Brigham
 *COSC 4785
 *9/24/2017*/

#include<string>
#include<iomanip>
#define PUNCTUATION 1
#define RELATIONOP 2
#define SUMOP 3
#define PRODUCTOP 4
#define UNARYOP 5
#define OPERATOR 6
#define INTEGER 7
#define FLOAT 8
#define SCIENTIFIC 9
#define KEYWORD 10
#define IDENTIFIER 11
#define NEWLINE 12
#define UNKNOWN 99
#define SINGLE_ERROR 100
#define WORD_ERROR 101
class Token {

private:
  int _line;	
  int _type;
  int _length;
  const char* _value;
  const char* _token;
public:
  static int _column;  

/*constructor initializes everything to -1
  to aviod errors. For example, calling the print function
  before setting the variables */
  Token() 
  {
    _token = "-1";
    _type = -1;
    _line = 1;
    _length = -1;
    _value = "";
  }  
  ~Token(){} 

  void setLine(int line)
  {
    _line = line;
  }

  void  setColumn(int length)
  {
    _column+= length;
  }

  void resetColumn()
  {
    _column = 1;
  }

  void  setType(int type)
  {
    // if a space is matched make that type 0
    if(type == 10)
      type = 0;
    _type =  type;
  }

  void  setLength(int length)
  {
    _length = length;
  }

  void setToken(const char* token)
  {
    _token = token;
  }

  void  setValue(int type )
  {
    switch(type)
    {
      case PUNCTUATION: 
	_value = "PUNCTUATION";
	break;

      case RELATIONOP: 
	_value = "RELATIONOP";
	break;

      case SUMOP: 
	_value = "SUMOP";
	break;

      case PRODUCTOP: 
	_value = "PRODUCTOP";
	break;

      case UNARYOP: 
	_value = "UNARYOP";
	break;

      case OPERATOR: 
	_value = "OPERATOR";
	break;

      case INTEGER: 
	_value = "INTEGER";
	break;

      case FLOAT:
	_value = "FLOAT";
	break;

      case SCIENTIFIC:
	_value = "SCIENTIFIC";
	break;

      case KEYWORD:
	_value = "KEYWORD";
	break;

      case IDENTIFIER:
	_value = "IDENTIFIER";
	break;

      case UNKNOWN:
	_value = "UNKNOWN";
	break;

      case SINGLE_ERROR:
	_value = "SINGLE ERROR";
	break;

      case WORD_ERROR:
	_value = "WORD ERROR";
	break;

      default:
	_value = "";
	break;
    }
  }

  void clear()
  {
    _value = "";
    _token= "";
  }

  void  print()
  {
/*    if(_type == 8 || _type == 0 || _type == 1)
    {
      _token = "";
    }
*/
     std::cout << " " << std::setw(10) << std::left << _line
               << " " << std::setw(10) << std::left << _column
               << " " << std::setw(20) << std::left << _token
               << " " << std::setw(20) << std::left << _value
     << std::endl;
    
  }
};
