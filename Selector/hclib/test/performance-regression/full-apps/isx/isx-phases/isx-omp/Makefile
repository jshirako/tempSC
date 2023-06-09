include $(HCLIB_ROOT)/../modules/system/inc/hclib_system.pre.mak
include $(HCLIB_ROOT)/../modules/openshmem/inc/hclib_openshmem.pre.mak
include $(HCLIB_ROOT)/include/hclib.mak
include $(HCLIB_ROOT)/../modules/system/inc/hclib_system.post.mak
include $(HCLIB_ROOT)/../modules/openshmem/inc/hclib_openshmem.post.mak


CC = $(OPENSHMEM_INSTALL)/bin/oshcc
LD = $(CC)
DEBUGFLAGS = -g -p -O0 -DDEBUG
OPTFLAGS = -O3 -DNDEBUG -mavx
CFLAGS += -DDAVINCI_DATASET -Wall -Wextra -std=c++11 -fopenmp $(HCLIB_CFLAGS) $(HCLIB_OSHMEM_CFLAGS) #$(OPTFLAGS)
LDLIBS += -lrt -lm -fopenmp $(HCLIB_LDLIBS) $(HCLIB_OSHMEM_LDLIBS)
LDFLAGS += $(HCLIB_LDFLAGS) $(HCLIB_OSHMEM_LDFLAGS)
###
# If you change these values, you must also change them in params.h
STRONG = 1
WEAK = 2
WEAKISO = 3
###

.PHONY: all clean debug

SRCS := main.cpp sort.cpp util.cpp pcg_basic.cpp verification.cpp
OBJDIR := obj
BINDIR := bin
STRONG_EXE = isx.strong
WEAK_EXE = isx.weak
WEAKISO_EXE = isx.weak_iso
STRONG_OBJS := $(SRCS:.cpp=.o_s)
STRONG_OBJS := $(addprefix $(OBJDIR)/,$(STRONG_OBJS))
WEAK_OBJS := $(SRCS:.cpp=.o_w)
WEAK_OBJS := $(addprefix $(OBJDIR)/,$(WEAK_OBJS))
WEAKISO_OBJS := $(SRCS:.cpp=.o_wi)
WEAKISO_OBJS := $(addprefix $(OBJDIR)/,$(WEAKISO_OBJS))

all: $(STRONG_EXE) $(WEAK_EXE) $(WEAKISO_EXE)

optimized: CFLAGS += $(OPTFLAGS)
optimized: all

debug: CFLAGS += $(DEBUGFLAGS)
debug: all

$(STRONG_EXE):$(STRONG_OBJS)
	@mkdir -p $(BINDIR)
	$(LD) $(STRONG_OBJS) -o $(BINDIR)/$(STRONG_EXE) $(LDLIBS) $(LDFLAGS)

$(WEAK_EXE):$(WEAK_OBJS)
	@mkdir -p $(BINDIR)
	$(LD) $(WEAK_OBJS) -o $(BINDIR)/$(WEAK_EXE) $(LDLIBS) $(LDFLAGS)

$(WEAKISO_EXE):$(WEAKISO_OBJS)
	@mkdir -p $(BINDIR)
	$(LD) $(WEAKISO_OBJS) -o $(BINDIR)/$(WEAKISO_EXE) $(LDLIBS) $(LDFLAGS)

$(OBJDIR)/%.o_s : %.cpp
	@mkdir -p $(OBJDIR)
	$(CC) $(CFLAGS) -D SCALING_OPTION=$(STRONG) -c $< -o $@

$(OBJDIR)/%.o_w: %.cpp
	@mkdir -p $(OBJDIR)
	$(CC) $(CFLAGS) -D SCALING_OPTION=$(WEAK) -c $< -o $@

$(OBJDIR)/%.o_wi: %.cpp
	@mkdir -p $(OBJDIR)
	$(CC) $(CFLAGS) -D SCALING_OPTION=$(WEAKISO) -c $< -o $@

clean:
	@- $(RM) $(BINDIR)/*
	@- $(RM) $(OBJDIR)/*

depend:
	    makedepend -- $(CFLAGS) -- $(SRCS)

# Don't place anything below this line, since
# # the make depend program will overwrite it
# # DO NOT DELETE THIS LINE -- make depend depends on it.