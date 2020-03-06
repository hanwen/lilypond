# make/Stepmake.make

# Use same configuration, but different output directory:
#
#     make out=www
#
# uses config.make and config.h; output goes to out-www.
#
ifdef out
  outbase=out-$(out)
else
  outbase=out
endif

ifdef config
  config_make=$(config)
else
  config_make=$(depth)/config.make
endif

outroot=.

include $(config_make)

include $(depth)/make/toplevel-version.make

#
# suggested settings
#
# CPU_COUNT=2   ## for SMP/Multicore machine
#
-include $(depth)/local.make

BUILD_VERSION=1

top-build-dir := $(realpath $(depth) )
build-dir := $(realpath  . )

tree-dir = $(subst $(top-build-dir),,$(build-dir))

outdir=$(top-build-dir)/$(outbase)/$(tree-dir)

outdir_for=$(top-build-dir)/$(outbase)/$(1)

# why not generic ??
config_h=$(top-build-dir)/config.hh

# The outdir that was configured for: best guess to find binaries
outconfbase=out

# user package
stepdir = $(stepmake)/stepmake

STEPMAKE_TEMPLATES := generic $(STEPMAKE_TEMPLATES)
LOCALSTEPMAKE_TEMPLATES:= generic $(LOCALSTEPMAKE_TEMPLATES)

# "delete the target of a rule if it has changed and its recipe exits
# with a nonzero exit status" (GNU make manual)
.DELETE_ON_ERROR:

# Keep this empty to prevent make from removing intermediate files.
.SECONDARY:

# The default verbosity is terse, which ideally prints one short line
# per target of interest in addition to warnings and errors.
#
# "make VERBOSE=1 ..." prints all commands as make normally does.  It
# may also increase the verbosity of some of the commands.
#
# "make SILENT=1 ..." works like "make -s ..." normally does.  It may
# also reduce the verbosity of some of the commands.  Note that
# $(findstring s,$(MAKEFLAGS)) does not imply SILENT=1 because the -s
# flag is set internally to achieve terse output.

ifdef SILENT # validate
  ifneq ($(SILENT),1)
    $(error Unexpected option SILENT=$(SILENT))
  endif
endif

ifdef VERBOSE # validate
  ifneq ($(VERBOSE),1)
    $(error Unexpected option VERBOSE=$(VERBOSE))
  endif
endif

ifdef SILENT
  ifdef VERBOSE
    $(error Conflicting options SILENT=$(SILENT) and VERBOSE=$(VERBOSE))
  endif
endif

ifdef SILENT
  .SILENT:
else
  ifndef VERBOSE
    .SILENT:
    # print the terse message for a target
    define ly_info
      echo '$(1)'
    endef
  else # verbose
    # print the terse message as a comment; make will print the commands
    define ly_info
      # $(1)
    endef
  endif
endif

# print a message about build progress
#
# $(1) = process, operation, or command
# $(2) = target file, i.e. $@ in a recipe
# $(3) = comment
define ly_progress
  $(call ly_info,$(1) $(subst $(configure-builddir)/,,$(abspath $(2))) $(3))
endef

all:

-include $(addprefix $(depth)/make/,$(addsuffix -inclusions.make, $(LOCALSTEPMAKE_TEMPLATES)))

-include $(addprefix $(stepdir)/,$(addsuffix -inclusions.make, $(STEPMAKE_TEMPLATES)))


include $(addprefix $(stepdir)/,$(addsuffix -vars.make, $(STEPMAKE_TEMPLATES)))

# ugh. need to do this because of PATH :=$(top-src-dir)/..:$(PATH)
include $(addprefix $(depth)/make/,$(addsuffix -vars.make, $(LOCALSTEPMAKE_TEMPLATES)))


include $(addprefix $(depth)/make/,$(addsuffix -rules.make, $(LOCALSTEPMAKE_TEMPLATES)))
include $(addprefix $(stepdir)/,$(addsuffix -rules.make, $(STEPMAKE_TEMPLATES)))
include $(addprefix $(depth)/make/,$(addsuffix -targets.make, $(LOCALSTEPMAKE_TEMPLATES)))
include $(addprefix $(stepdir)/,$(addsuffix -targets.make, $(STEPMAKE_TEMPLATES)))
