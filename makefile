CXX=g++
CXXFLAGS=-ggdb -std=c++11 -Wall
YACC=bison
YFLAGS=--report=state -W -d
LEX=flex
LEXXX=flex++
LFLAGS=--warn

all: program.tab.c program.tab.h program.cpp scope.h program_lex.cpp node.hpp
	$(CXX) $(CXXFLAGS) program_lex.cpp program.tab.c program.cpp -o program5

program.tab.c: program.y node.hpp scope.h
	$(YACC) $(YFLAGS) program.y

program_lex.cpp: program.lpp
	$(LEXXX) $(LFLAGS) program.lpp

clean:
	rm -f *.o a.out core.* program_lex.cpp program.tab.* program.output
