################################################################################
#
# Makefile for C/C++ MySQL applications
#
# Revision History
#	12 Apr 2022: PASW: 	Initial Drop
#       22 Dec 2022; PASW:	Changed linking to use mysql_config
#
# These are the flags that gcc/g++ requires in order to link correctly
#

MYSQL_CXXFLAGS := $(shell mysql_config --cxxflags)
MYSQL_LIBS := $(shell mysql_config --libs)

CPP_BE_GOOD_OPTIONS := -fno-rtti -fno-exceptions

CC = gcc
CXX = g++

CDEBUG = -g -Wall

CXXDEBUG = -g -Wall

CFLAGS = $(CDEBUG) $(CSTD) 
CXXFLAGS = $(CXXDEBUG) $(MYSQL_CXXFLAGS)

TARGET = showDatabasesSample

# Filenames with extensions; CPP_SRCS does NOT include the target source file
# If you have ZERO additional CPP_SRCS files you will need to removed CPP_OBJS
# references in the rules below
CPP_SRCS = $(TARGET).cpp
CPP_OBJS = $(addsuffix .o, $(basename $(CPP_SRCS)))
HEADERS = 

CLEAN =	$(CPP_OBJS) $(TARGET).o

$(TARGET): $(CPP_SRCS)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(CPP_SRCS) $(MYSQL_LIBS)

# Keeping things clean

.PHONY: all clean realclean

all: $(TARGET)

clean:
	rm -rf $(CLEAN) *~

realclean: clean
	rm -f $(TARGET)


