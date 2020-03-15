import os
import re

def subst_ext(fn, e1, e2):
    fn = trim_pre(fn, "../")
    base, ext = os.path.splitext(fn)
    assert ext == e1, (fn, e1)
    return base + e2

def trim_pre(s, p):
    if s.startswith(p):
        return s[len(p):]
    return s

implicit_deps = {
    "lily/general-scheme.o": ["version.hh"],
    "lily/lexer.o": ["lily/parser.hh"],
    "lily/lily-lexer-scheme.o": ["lily/parser.hh"],
    "lily/lily-lexer.o": ["${FLEXLEXER_FILE}","lily/parser.hh"],
    "lily/lily-parser-scheme.o": ["lily/parser.hh"],
    "lily/lily-parser.o": ["lily/parser.hh"],
    "lily/lily-version.o": ["version.hh"],
    "lily/parse-scm.o": ["lily/parser.hh"],
    "lily/relocate.o": ["version.hh"],
    "lily/sources.o": ["lily/parser.hh"],
}

class Gen:
    def __init__(self, f):
        self._nf = f

    def build(self, rule, outputs, inputs, implicit_outputs=[], implicit_inputs=[]):
        assert type(outputs) == list, outputs
        assert type(inputs) == list, inputs
        implicit_inputs =  implicit_inputs[:]
        for o in outputs:
            if o in implicit_deps:
                implicit_inputs += implicit_deps[o]

        imp_deps_str = ' '.join(implicit_inputs)
        imp_out_str = ' '.join(implicit_outputs)
        r = "build %s | %s: %s %s || %s\n" % (' '.join(outputs), imp_out_str, rule, ' '.join(inputs), imp_deps_str)
        self._nf.write(r)

    def cc(self, input):
        out = subst_ext(input, ".cc", ".o")
        self.build("cc", [out], [input])
        return out

    def yy(self, input):
        cc = subst_ext(input, ".yy", ".cc")
        hh = subst_ext(input, ".yy", ".hh")
        self.build("bison", [cc], [input], implicit_outputs=[hh])
        return self.cc(cc)
    def ll(self, input):
        cc = subst_ext(input, ".ll", ".cc")
        hh = subst_ext(input, ".ll", ".hh")
        self.build("flex", [cc], [input], implicit_outputs=[hh])
        return self.cc(cc)
    def cc_exe(self, out, inputs):
        self.build("cc_exe", [out], inputs)
        self.build("exe_manpage", [out + ".1"],  [out], implicit_inputs=["$help2man"])
    def at_substitute(self, input):
        out, _ = os.path.splitext(input)
        out = trim_pre(out, "../")
        self.build("at_substitute", [out], [input])

    def mf_to_pfb(self, input):
        self.build("mf_to_pfb", [
            subst_ext(input, ".mf", ".pfb"),
            subst_ext(input, ".mf", ".tfm"),
            subst_ext(input, ".mf", ".log"),
        ], [input], implicit_inputs=["scripts/build/mf2pt1"])
        self.build("mflog_to_lisp",
                   [subst_ext(input, ".mf", ".lisp"),
                    subst_ext(input, ".mf", ".global-lisp")],
                   [subst_ext(input, ".mf", ".log")],
                   implicit_inputs=["scripts/build/mf-to-table"])


atvars = [
  "BASH",
  "BUILD_VERSION",
  "DATE",
  "FONTFORGE",
  "GUILE",
  "MAJOR_VERSION",
  "MINOR_VERSION",
  "NCSB_DIR",
  "PATCH_LEVEL",
  "PATHSEP",
  "PERL",
  "PYTHON",
  "SHELL",
  "TARGET_PYTHON ",
  "TOPLEVEL_VERSION",
  "bindir",
  "datadir",
  "date",
  "lilypond_datadir",
  "lilypond_docdir",
  "lilypond_libdir",
  "local_lilypond_datadir",
  "local_lilypond_libdir",
  "localedir",
  "outdir",
  "prefix",
  "program_prefix",
  "program_suffix",
  "sharedstatedir",
  "src-dir",
  "top-src-dir"]

preamble = """

help2man = scripts/build/help2man

rule cc
  command = $CXX $CONFIG_CXXFLAGS -I lily -I ../flower/include -I ../lily/include/ -I ../ -I. -c -o $out $in

rule bison
  command = $BISON -d -o $out $in

rule flex
  command = $FLEX -Cfe -p -p -o$out $in

rule make-version
  command = python ../scripts/build/make-version.py $in > $out

rule cc_exe
  command = $CXX $CONFIG_CXXFLAGS -o $out $in $CONFIG_LIBS

rule exe_manpage
  command = $PERL $help2man $in > $out

build version.hh: make-version ../VERSION

rule mf_to_pfb
  command = mf/invoke-mf2pt.sh scripts/build/mf2pt1 $in $out

rule mflog_to_lisp
  command = scripts/build/mf-to-table $in


"""

preamble += """
rule at_substitute
  command = sed '%s' < $in > $out && chmod +x $out
""" % ';'.join(['s#@%s@#$%s#' % (v,v) for v in atvars])

files = []
dirs = set([])
for l in os.popen('git ls-tree -r HEAD --name-only'):
    files.append(l.strip())
    dirs.add(os.path.dirname(l.strip()))

os.makedirs("build", exist_ok=True)
os.chdir("build")

ninja = open('build.ninja', 'w')

with open("../config.make") as f:
    for l in f:
        if "$" in l:
            continue
        ninja.write(l)

ninja.write(preamble)
gen = Gen(ninja)


dirs = set([os.path.dirname(f) for f in files])
for d in dirs:
    if d:
        os.makedirs(d, exist_ok=True)

objs = []
for f in files:
    if f.endswith(".make") or "GNUmakefile" in f:
        continue

    if os.path.exists(f):
        os.remove(f)
    os.symlink("../" *len(f.split("/")) + f, f)

    if f.startswith("scripts/") and not f.endswith(".tely"):
        gen.at_substitute(f)
    if f.endswith(".cc"):
        objs.append(gen.cc(f))
    if f.endswith(".yy"):
        objs.append(gen.yy(f))
    if f.endswith(".ll"):
        objs.append(gen.ll(f))
    if re.search(r"[a-z-]*[0-9]+\.mf$", f) or re.search("feta-braces-[a-z]\.mf$",f):
        gen.mf_to_pfb(f)

gen.cc_exe("lilypond", [o for o in objs if "flower/test" not in o])

ninja.close()
