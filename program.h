/*program2.h
 *Dylan Brigham
 *COSC 4785
 *9/24/2017*/

#include<string>
#include<iomanip>


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
      case 10: 
	_value = "SPACE";
	break;
     
      case 1: 
	_value = "TAB";
	break;
   
      case 2: 
	_value = "PUNCTUATION";
	break;

      case 3: 
	_value = "OPERATOR";
	break;

      case 4: 
	_value = "INTEGER";
	break;

      case 5: 
	_value = "FLOAT";
	break;

      case 6: 
	_value = "SCIENTIFIC";
	break;

      case 7: 
	_value = "IDENTIFIER";
	break;

      case 8: 
	_value = "NEWLINE";
	break;

      case 9:
	_value = "SINGLE ERROR";
	break;

      case 99:
	_value = "WORD ERROR";
	break;

      case 15:
	_value = "RELATIONOP";
	break;

      case 12:
	_value = "SUMOP";
	break;

      case 13:
	_value = "PRODUCTOP";
	break;

      case 14:
	_value = "UNARYOP";
	break;

      case 16:
	_value = "KEYWORD";
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
    if(_type == 8 || _type == 0 || _type == 1)
    {
      _token = "";
    }

     std::cout << " " << std::setw(10) << std::left << _line
               << " " << std::setw(10) << std::left << _column
               << " " << std::setw(20) << std::left << _token
               << " " << std::setw(20) << std::left << _value
     << std::endl;
    
  }
};
