# compiler-decaf

Author: Dylan Brigham
Date: 11-3-2017

Program Notes: The program currently contains only 1 shift/reduce error. This error was 
               expected due to the dangling else, so I decided to suppress it with %expect 1.
               The grammar should be correct, and both line and block comments are ignored, as
               well as whitespace. The only major issues I experienced with this program was when
               handling errors. The error line number for block type expressions will report at the
               end of that grammar, NOT were the actual error exists. Other expressions though, do 
               correctly report the line number where the error exists. 


Error Handling: I decided to do error handling around ClassDeclaration, ClassBody, VarDeclaration
                Block, and Statement. I choose these grammars to focus on because these seem to be
                fairly unique. Also, I decide to use ClassBody, and Block because these can encompass
                a more broad range of errors. 


Problems:      Currently, I was not able to figure out how to print a line or statement
               once an error token was recognized. I would really like to be able to do this
               in the future.

               Another issue I ran across and is still currently a huge bug in my code is
               error checking nonmatching braces or parenthesis. This does not allow for a proper recovery. I tried
               fixing this issue, but ultimately I was not able to find a solution that would
               not cause the rest of the code problems.
