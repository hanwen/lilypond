import fontforge
import getopt
import os
import psMat
import re
import sys

(options, files) = \
 getopt.getopt (sys.argv[1:],
                '',
                ['in=', 'out=', 'version='])

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

font = fontforge.font()

scale = 1.0
subfonts = []
for c in "abcdefghi" :
    subfont = "feta-braces-%s" %c
    subfonts.append(subfont)
    f = fontforge.open(os.path.join(indir, subfont + ".pfb"))
    f.selection.all()
    f.transform(psMat.scale(scale))

    # mergeFonts takes a font, but this is a recent innovation fo
    # b53e885e Aug 28, 2018 "Allow passing a font object to
    # mergeFonts()"
    tmp = "tmp.feta-brance-scaled.pfb"
    f.generate(tmp)
    font.mergeFonts(tmp)
    scale += 1.0

font.fontname= "Emmentaler-Brace"
font.familyname = "Emmentaler-Brace"
font.weight = "Regular"
font.copyright = "GNU GPL"
font.version = version

# Set code points to PUA (Private Use Area)
i = 0
for glyph in font.glyphs():
    glyph.unicode = i + 0xE000
    i += 1

subfonts_str = ' '.join (subfonts)


lisp = b""
for sub in subfonts:
    lisp += open(os.path.join(indir, sub) + ".lisp", "rb").read()

font.setTableData("LILF", subfonts_str.encode("ascii"))
font.setTableData("LILC", lisp)
font.setTableData("LILY", b'(design_size . 20)')

font.generate(output)
base, ext = os.path.splitext(output)

font.generate(base + ".svg")
font.generate(base + ".woff")
