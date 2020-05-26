CXX = g++

CXXFLAGS= -O0 -std=c++11 -g -lm -Wall -pedantic

EXE_NAME=verilog_gen
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

gen_204:
	rm -rf 204.33.484_rtl
	mkdir 204.33.484_rtl
	./$(EXE_NAME) lut_in2_204_102.csv 4 
	mv *.v 204.33.484_rtl/

clean: 
	rm -f $(REBUILDABLES) *.dep *.deppo *~ *.o *.txt
	#rm -rf $(RTL_GEN_DIR)
