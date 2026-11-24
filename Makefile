# Makefile - largest_number_finder
CXX      ?= g++
CXXFLAGS ?= -std=c++17 -Wall -Wextra -pedantic -O2

SRC    := src/largest_number_finder.cpp
TARGET := bin/largest_number_finder

.PHONY: all run test clean

all: $(TARGET)

$(TARGET): $(SRC) | bin
	$(CXX) $(CXXFLAGS) -o $@ $<

bin:
	mkdir -p bin

run: $(TARGET)
	./$(TARGET)

test: $(TARGET)
	bash tests/run_tests.sh $(TARGET)

clean:
	rm -rf bin
