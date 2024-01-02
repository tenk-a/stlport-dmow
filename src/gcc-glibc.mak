#
# compiler
#
CC = gcc
CXX = c++

#
# Basename for libraries
#
LIB_BASENAME = libstlport_gcc

#
# guts for common stuff
#
#
LINK=ar crv
DYN_LINK=gcc -shared -o

OBJEXT=o
DYNEXT=so
STEXT=a
RM=rm -rf
PATH_SEP=/
MKDIR=mkdir -p
COMP=GCC$(ARCH)

all: msg all_dynamic all_static

msg:
	@echo "*** ATTENTION! ***"
	@echo "This makefile tries to use system locale which might not work well with all glibc flavours."
	@echo "If build fails, please resort to gcc.mak which will build C-locale only version for STLport 4.0"
	@echo "******************"
include common_macros.mak

WARNING_FLAGS= -W -Wno-sign-compare -Wno-unused -Wno-uninitialized -D__STL_USE_GLIBC

CXXFLAGS_COMMON = -I${STLPORT_DIR} ${WARNING_FLAGS} -D__STL_REAL_LOCALE_IMPLEMENTED

CXXFLAGS_RELEASE_static = $(CXXFLAGS_COMMON) -O2
CXXFLAGS_RELEASE_dynamic = $(CXXFLAGS_COMMON) -O2 -fpic

CXXFLAGS_DEBUG_static = $(CXXFLAGS_COMMON) -g
CXXFLAGS_DEBUG_dynamic = $(CXXFLAGS_COMMON) -g -fpic

CXXFLAGS_STLDEBUG_static = $(CXXFLAGS_DEBUG_static) -D__STL_DEBUG
CXXFLAGS_STLDEBUG_dynamic = $(CXXFLAGS_DEBUG_dynamic) -D__STL_DEBUG -fpic

include common_percent_rules.mak
include common_rules.mak


#install: all
#	cp -p $(LIB_TARGET) ${D_LIB_TARGET} ../lib

#%.s: %.cpp
#	$(CXX) $(CXXFLAGS) -O4 -S -pto $<  -o $@


