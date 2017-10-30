#
# Skynek Fluid builder
#
# Version: 1.5.2
# Compiler: GCC
#

# Compilation settings

WARNINGS := -Wall -Wextra -pedantic -Wshadow -Wpointer-arith -Wcast-align	\
			-Wwrite-strings -Wmissing-prototypes -Wmissing-declarations		\
			-Wredundant-decls -Wnested-externs -Winline -Wno-long-long		\
			-Wuninitialized -Wconversion -Wstrict-prototypes

CFLAGS ?= -std=gnu99 -g $(WARNINGS) -fpic

# Project structure

OBJDIR := Objects
OUTDIR := Outputs
SRCDIR := Sources
HDRDIR := Headers
RDSDIR := Ressources

NAME := project_$(shell uname -m)-$(shell uname -s)

# Options

ifeq ($(VERBOSE), 1)
		SILENCER :=
else
		SILENCER := @
endif

ifeq ($(DEBUG_BUILD), 1)
		CFLAGS +=-DDEBUG_BUILD
endif

# Sources files

SRCF := main.c

# Compilator

SRCS := $(patsubst %, $(SRCDIR)/%, $(SRCF))
OBJS := $(patsubst %, $(OBJDIR)/%, $(SRCF:c=o))

# Compilation output configurations

CFLAGS += -MMD -MP
DEPS := $(patsubst %, $(OBJDIR)/%, $(SRCF:c=d))

# Compilation command

all: $(NAME)
	clear
	cd /Sources && find . -type d -exec mkdir -p /Objects/{} \;
	cd ..

# Automated compilator

$(NAME): $(OBJS)
	$(SILENCER)mkdir -p $(OUTDIR)
	$(SILENCER)$(CC) $(CFLAGS) -o $(OUTDIR)/$(NAME) $^

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	$(SILENCER)mkdir -p $(OBJDIR)
	$(SILENCER)$(CC) $(CFLAGS) -c -o $@ $<

# Helpers command

init:
	$(SILENCER)mkdir -p $(OBJDIR)
	$(SILENCER)mkdir -p $(SRCDIR)
	$(SILENCER)mkdir -p $(HDRDIR)
	$(SILENCER)mkdir -p $(RDSDIR)

clean:
	clear
	$(SILENCER)find . -name "*.o" -type f -delete
	$(SILENCER)find . -name "*.d" -type f -delete

fclean: clean
	$(SILENCER)$(RM) -rf $(OUTDIR)
	$(SILENCER)$(RM) -rf $(OBJDIR)

re: fclean all

.PHONY: re fclean clean init all

-include $(DEPS)
