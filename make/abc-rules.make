.SUFFIXES: .abc

$(outdir)/%.ly:  %.abc
	$(PYTHON) $(ABC2LY) --quiet -o $@ $<
