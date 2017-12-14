# compiler-decaf

Author: Dylan Brigham
Date: 12-14-2017

Note:            The grammar you provided us and the files you are using to test do not
                 match. For example we were given the updated grammer of:
                 
                 NewExpression -> new identifier (Arglist)
                                 |new SimpleType <[Expression]>*<[]>*

                 But in one of the test file you were attemping something similiar to:
                 
                 d = new goo [10][];

                 My program errored during this because my grammar does not accept the above
                 expression. This seemed to be the issue with my program5 and will probably be the
                 same issue with program6 if you attempt the same expression.


Problems:        Currently, I was not able to figure out how to print a line or statement
                 with the error messages, the line number tends to be off. 

                 Also, a known bug this time around is when declaring a method, 
                 parameters used within the scope of the method are not type checked. 
                 Parameters used within a method, unless explicitly declared will not catch type errors.
                 I was too deep into the program to go back and make this fix with fear of messing
                 up everything else.
 
                 A bug from the previous assignments is that missing braces, parenthesis, or brackets
                 can cause the parse tree to not be constructed.


How to Compile:  I am using a makefile. And the executable is name program6. All you should 
                 need to type is:

                 make
                 ./program6 <  <name of file>

