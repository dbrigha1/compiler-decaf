# compiler-decaf

Author: Dylan Brigham
Date: 10-20-2017

Program Notes: The program currently contains 5 shift/reduce errors. 
               3 of these shift reduce errors appeared when making the 
               program more accessible for grading, since var decs and expressions
               do not merge in the parts of the grammar that we programmed. The
               other two shift/reduce errors occured while error handling,
               this occured because the areas that I added the error handling
               cause ambiguouity because more than one grammer can reduce the token. 


Error Handling: I decided to base the error off of the '\n', ';', and '[]' tokens.
                I made this decision because when differenciating between
                var declarations and expressions, expressions do not contain
                a semi colon while var declarations do. I also decided to break
                var declarations even more by recognizing the type by braces. This
                part of the program was definitely the most challenging and many problems
                occured. 

                The format in which I decided to to print the errors is similiar to yours:
               
               ex. Variable Declaration Error: line:2  ?;

               As I will  mention in the next section, the '?' is a placeholder for the line or statement
               that is causing the error. 


Problems:      Currently, I was not able to figure out how to print a line or statement
               once an error token was recognized. Because of this, I substituted where
               the statement would occur with '?'. I am hoping to get this figured out
               by the next program. 

               Another issue I ran across and is still currently a huge bug in my code is
               error checking nonmatching braces. THIS CAUSES A SEGMENTATION FAULT. I tried
               fixing this issue, but ultimately I was not able to find a solution that would
               not cause the rest of the code problems.

               Hopefully, I can solve these issues by the next programming assignment. 
