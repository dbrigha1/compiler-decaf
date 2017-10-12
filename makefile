
all: program.cpp program.h program_lex.cpp program.lpp
	g++ -ggdb program_lex.cpp program.cpp

program_lex.cpp: program.lpp
	flex++ --warn program.lpp

clean:
	rm -f *.o a.out core.* program_lex.cpp
	
