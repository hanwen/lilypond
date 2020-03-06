
depth = ..

NAME = lilypond

MODULE_LIBS=$(depth)/flower
MODULE_INCLUDES= $(depth)/flower/include


HELP2MAN_EXECS = lilypond
STEPMAKE_TEMPLATES=c++ po help2man

include $(depth)/make/stepmake.make

EXECUTABLE = $(outdir)/$(NAME)
EXECUTABLES = $(notdir $(EXECUTABLE))

ifeq ($(LINK_GXX_STATICALLY),yes)
MODULE_LDFLAGS += -L$(outdir) -static-libgcc
endif

# for profiling, link guile statically:
#
# CONFIG_LDFLAGS += -static -lltdl -ldl
#

ifeq ($(PLATFORM_WINDOWS),yes)
WINDRES_FLAGS += -DLilyPond=0 -DLY=1
O_FILES += $(outdir)/lilypond.rc.o
$(outdir)/lilypond: $(outdir)/lilypond.rc.o

$(outdir)/lilypond.rc.o: $(outdir)/lilypond.ico $(outdir)/ly.ico \
	$(src-dir)/lilypond.manifest
$(top-build-dir)/Documentation/logo/$(outbase)/lilypond.ico:
	$(MAKE) -C $(top-build-dir)/Documentation/logo

$(outdir)/lilypond.ico: $(top-build-dir)/Documentation/logo/$(outbase)/lilypond.ico
	$(call ly_progress,Making,$@,(copy))
	cp $< $@

$(top-build-dir)/Documentation/logo/$(outbase)/ly.ico:
	$(MAKE) -C $(top-build-dir)/Documentation/logo

$(outdir)/ly.ico: $(top-build-dir)/Documentation/logo/$(outbase)/ly.ico
	$(call ly_progress,Making,$@,(copy))
	cp $< $@
endif

ETAGS_FLAGS += --regex='{c++}/^LY_DEFINE *(\([^,]+\)/\1/'
ETAGS_FLAGS += --regex='{c++}/^LY_DEFINE *([^"]*"\([^"]+\)"/\1/'

default: $(EXECUTABLE)

exe: $(EXECUTABLE)

local-install: installexe

local-uninstall: uninstallexe

installexe: all
	-$(INSTALLPY) -d $(DESTDIR)$(bindir)
	$(foreach a, $(EXECUTABLES), \
		$(INSTALLPY) -m 755 $(outdir)/$(a) \
		$(DESTDIR)$(bindir)/$(program_prefix)$(a)$(program_suffix) && ) true
	$(INSTALLPY) -c -m 755 $(addprefix $(outdir)/, $(SEXECUTABLES)) $(DESTDIR)$(bindir)

uninstallexe:
	$(foreach a, $(EXECUTABLES), rm -f \
		$(DESTDIR)$(bindir)/$(program_prefix)$(a)$(program_suffix) && ) true
	$(foreach a, $(SEXECUTABLES), rm -f $(DESTDIR)$(bindir)/$(a) &&) true


FLOWER_LIB=$(call outdir_for,flower)/library.a

$(EXECUTABLE): $(O_FILES) $(outdir)/version.hh $(FLOWER_LIB)
	$(call ly_progress,Making,$@,)
	make -C ../flower
	$(CXX) $(ALL_CXXFLAGS) -o $@ $(O_FILES) $(FLOWER_LIB) $(CONFIG_LIBS) $(ALL_LDFLAGS)


$(outdir)/libstdc++.a:
	$(call ly_progress,Making,$@,(symlink))
	rm -f $@
	ln -s `$(CXX) -print-file-name=libstdc++.a` $(outdir)

ifeq ($(LINK_GXX_STATICALLY),yes)
$(outdir)/lilypond: $(outdir)/libstdc++.a
endif

# force these: Make can't know these have to be generated in advance
$(outdir)/lily-parser.o $(outdir)/parser.o: $(outdir)/parser.hh
$(outdir)/lily-lexer.o: $(outdir)/parser.hh $(FLEXLEXER_FILE) $(config_h)
$(outdir)/lexer.o: $(outdir)/parser.hh $(outdir)/version.hh
$(outdir)/lily-lexer-scheme.o \
  $(outdir)/lily-parser-scheme.o \
  $(outdir)/parse-scm.o \
  $(outdir)/sources.o: $(outdir)/parser.hh

$(outdir)/lexer.cc: $(config_h)
$(outdir)/parser.cc: $(config_h)

ifneq ($(LILYPOND_EXTERNAL_BINARY),)
$(outdir)/lilypond.1: $(LILYPOND_EXTERNAL_BINARY) $(buildscript-dir)/help2man
	$(call ly_progress,Making,$@,)
	$(buildscript-dir)/help2man $(LILYPOND_EXTERNAL_BINARY) > $@
endif

$(outdir)/general-scheme.o: $(outdir)/version.hh
$(outdir)/lily-version.o: $(outdir)/version.hh
$(outdir)/relocate.o: $(outdir)/version.hh

local-po: $(outdir)/parser.cc
