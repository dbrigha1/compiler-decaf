# compiler-decaf

Author: Dylan Brigham
Date: 11-23-2017


Problems:        Currently, I was not able to figure out how to print a line or statement
                 with the error messages, the line number tends to be off. 

                 Also, a known bug this time around is when declaring a method, I could not figure how to
                 declare the parameters without actually declaring them in the same scope as 
                 the method. Because of this, parameters used within the scope of the method
                 are not type checked. Parameters used within a method, unless explicitly declared
                 will not catch type erros.
 
                 A bug from the previous assignments is that missing braces, parenthesis, or brackets
                 can cause the parse tree to not be constructed.


How to Compile:  I am using a makefile. And the executable is name program5. All you should 
                 need to type is:

                 make
                 ./program5 <  <name of file>

