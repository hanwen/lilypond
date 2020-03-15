import fontforge
import getopt
import sys
import re
import os

(options, files) = \
 getopt.getopt (sys.argv[1:],
                '',
                ['in=', 'out=', 'version='])

design_size = 0
version = "dev"
indir = ""
output = ""
for opt in options:
    o = opt[0]
    a = opt[1]
    if o == '--in':
        indir = a
    elif o == '--out':
        output = a
    elif o == '--version':
        version = a
    else:
        print(o)
        raise getopt.error

m = re.search(r"([0-9]*)\.otf", output)
assert m, repr(output)

design_size = int(m.group(1))

font = fontforge.font()
font.familyname = "Emmentaler-%d" % design_size
font.fontname = font.familyname
font.copyright = """This font is distributed under the GNU General Public License.
As a special exception, if you create a document which uses
this font, and embed this font or unaltered portions of this
font into the document, this font does not by itself cause the
resulting document to be covered by the GNU General Public License.
"""
font.version = version

subfonts = []
for fn in ["feta%(design_size)d.pfb",
           "feta-noteheads%(design_size)d.pfb",
           "feta-flags%(design_size)d.pfb",
           "parmesan%(design_size)d.pfb",
           "parmesan-noteheads%(design_size)d.pfb"]:
    name = fn%vars()
    font.mergeFonts(os.path.join(indir, name))

    name, _ = os.path.splitext(name)
    subfonts.append(name)

# Set code points to PUA (Private Use Area)
i = 0
for glyph in font.glyphs():
    glyph.unicode = i + 0xE000
    i += 1

alphabet = "feta-alphabet%(design_size)d" % vars()
font.mergeFonts(os.path.join(indir, alphabet + ".pfb"))
font.mergeFeature(os.path.join(indir, alphabet + ".tfm"))
subfonts.append(alphabet)

subfonts_str = ' '.join (subfonts)

lisp = b""
for sub in subfonts:
    lisp += open(os.path.join(indir, sub) + ".lisp", "rb").read()

font.setTableData("LILF", subfonts_str.encode("ascii"))
font.setTableData("LILC", lisp)
font.setTableData("LILY", open(os.path.join(indir, "feta%(design_size)d.global-lisp" % vars()), "rb").read());

font.generate(output)
base, ext = os.path.splitext(output)

font.generate(base + ".svg")
font.generate(base + ".woff")
