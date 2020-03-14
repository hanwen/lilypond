#!/usr/bin/python

import sys
import os
import getopt
import re

opts, args = getopt.getopt(
    sys.argv[1:], "",
    ["include=", "target=",])

includes = []
target = ""
for (k, v) in opts:
    if k == '--target':
        target = v
    elif k == '--include':
        includes.append(v)
    else:
        assert 0, k

assert target

def find_mf(fn):
    for i in includes:
        f = os.path.join(i, fn)
        if not f.endswith(".mf"):
            f += ".mf"
        if os.path.exists(f):
            return f
    assert 0, (fn, includes)

input = sys.argv[1]

input_re = re.compile("\n" + r"\s*input \s*([^;]*);")
def scan_mf(fn):
    deps = []
    with open(find_mf(fn), encoding="utf-8") as f:
        input_re.sub(lambda m: deps.append(m.group(1)), f.read())

    total = []
    for d in deps:
        full_path = find_mf(d)
        total.append(full_path)
        total += scan_mf(full_path)

    return total

print("%s: %s" % (target, ' '.join(scan_mf(args[0]))))
