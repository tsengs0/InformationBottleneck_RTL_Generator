CXX = g++

CXXFLAGS= -O0 -std=c++11 -g -lm -Wall -pedantic

EXE_NAME=verilog_gen
RTL_GEN_DIR=204.33.484_rtl 8000.4000.3.483_rtl
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
	./$(EXE_NAME) ../PCM/204.33.484.txt
	mv cnu*.v vnu*.v ib*.v 204.33.484_rtl/
	mv fully_parallel_*.v 204.33.484_rtl/

gen_8000:
	rm -rf 8000.4000.3.483_rtl
	mkdir 8000.4000.3.483_rtl
	./$(EXE_NAME) ../PCM/8000.4000.3.483.txt
	mv cnu*.v vnu*.v ib*.v 8000.4000.3.483_rtl/

clean: 
	rm -f $(REBUILDABLES) *.dep *.deppo *~ *.o *.txt
	#rm -rf $(RTL_GEN_DIR)
