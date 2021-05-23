CXX = g++

CXXFLAGS= -O0 -std=c++11 -g -lm -Wall -pedantic

EXE_NAME=main
# STATIC_LIB_NAME := libdramsim.a
# LIB_NAME=libdramsim.so
# LIB_NAME_MACOS=libdramsim.dylib

SRC = $(wildcard DRAM/*.cpp) $(wildcard *.cpp)
# $(info SRC is $(SRC))
OBJ = $(addsuffix .o, $(basename $(SRC)))

LIB_SRC := $(filter-out main.cpp,$(SRC))
# basename take the basic file name
LIB_OBJ := $(addsuffix .o, $(basename $(LIB_SRC)))

REBUILDABLES=$(OBJ) $(EXE_NAME)

all: ${EXE_NAME}

#   $@ target name, $^ target deps, $< matched pattern
$(EXE_NAME): $(OBJ)
	$(CXX) $(CXXFLAGS) -o $@ $^ 
	@echo "Built $@ successfully" 

%.o : %.cpp
	$(CXX) $(CXXFLAGS) -o $@ -c $<

run:
	./$(EXE_NAME) > log

clean: 
	rm -f $(REBUILDABLES) *.dep *.deppo *~ *.o *.txt
