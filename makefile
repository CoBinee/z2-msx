#! make -f
#
# makefile - start
#


# option
#

# build 0/1 = disk/rom
BUILDROM		=	1

# directory
#

# source file directory
SRCDIR			=	sources

# include file directory
INCDIR			=	sources

# object file directory
OBJDIR			=	objects

# binary file directory
BINDIR			=	bin

# output file directory
ifneq ($(BUILDROM), 0)
OUTDIR			=	rom
else
OUTDIR			=	disk
endif

# tool directory
TOOLDIR			=	tools

# vpath search directories
VPATH			=	$(SRCDIR):$(INCDIR):$(OBJDIR):$(BINDIR)

# assembler
#

# assembler command
AS				=	sdasz80

# assembler flags
ASFLAGS			=	-ls -I$(INCDIR) -I.

# c compiler
#

# c compiler command
CC				=	sdcc

# c compiler flags
CFLAGS			=	-mz80 --opt-code-speed -I$(INCDIR) -I.

# linker
#

# linker command
LD				=	sdcc

# linker flags
ifneq ($(BUILDROM), 0)
LDFLAGS			=	-mz80 --no-std-crt0 --nostdinc --nostdlib --code-loc 0x4020 --data-loc 0xc000
else
LDFLAGS			=	-mz80 --no-std-crt0 --nostdinc --nostdlib --code-loc 0x8410 --data-loc 0xc000
endif

# suffix rules
#
.SUFFIXES:			.s .c .rel

# assembler source suffix
.s.rel:
	$(AS) $(ASFLAGS) -o $(OBJDIR)/$@ $<

# c source suffix
.c.rel:
	$(CC) $(CFLAGS) -o $(OBJDIR)/$@ -c $<

# project files
#

# target name
TARGET			=	Z2

# assembler source files
ASSRCS			=	crt0.s \
					main.s System.s Math.s \
					App.s Sound.s \
					Title.s \
					Game.s Player.s Enemy.s Field.s \
					pattern.s

# c source files
CSRCS			=	

# object files
OBJS			=	$(ASSRCS:.s=.rel) $(CSRCS:.c=.rel)


# build project target
#
$(TARGET).com:		$(OBJS)
	$(LD) $(LDFLAGS) -o $(BINDIR)/$(TARGET).ihx $(foreach file,$(OBJS),$(OBJDIR)/$(file))
ifneq ($(BUILDROM), 0)
	$(TOOLDIR)/ihx2rom32k -o $(OUTDIR)/$(TARGET).ROM $(BINDIR)/$(TARGET).ihx
else
	$(TOOLDIR)/ihx2bload -o $(OUTDIR)/$(TARGET).BIN $(BINDIR)/$(TARGET).ihx
endif

# clean project
#
clean:
	@rm -f $(OBJDIR)/*
	@rm -f $(BINDIR)/*
##	@rm -f makefile.depend

# build depend file
#
depend:
##	ifneq ($(strip $(CSRCS)),)
##		$(CC) $(CFLAGS) -MM $(foreach file,$(CSRCS),$(SRCDIR)/$(file)) > makefile.depend
##	endif

# build resource file
#
resource:
	@$(TOOLDIR)/bin2s -n patternTable -o sources/pattern.s resources/pattern.chr

# build tools
#
tool:
	@gcc -o $(TOOLDIR)/bin2s $(TOOLDIR)/bin2s.cpp
	@gcc -o $(TOOLDIR)/ihx2bload $(TOOLDIR)/ihx2bload.cpp
	@gcc -o $(TOOLDIR)/ihx2rom32k $(TOOLDIR)/ihx2rom32k.cpp

# phony targets
#
.PHONY:				clean depend

# include depend file
#
-include makefile.depend


# makefile - end
