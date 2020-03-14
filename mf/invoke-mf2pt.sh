#!/bin/sh

set -eu
mf2pt1=$(realpath $1)
src=$(realpath $2)
target=$(realpath $3)

name=$(basename src .mf)

# mf2pt1 pollutes CWD, so run it in a tmp dir.
#
# the soft link for mf2pt1.mp is for recent mpost versions
# which no longer dump a .mem file
tmp=$(dirname $target)/tmp.$(basename $target)
rm -rf $tmp
mkdir $tmp
cd $tmp
ln -s ../mf2pt1.mem .
ln -s ../../mf2pt1.mp .
export MFINPUTS="$(dirname $src):..::"
export max_print_line=1000

${mf2pt1} --rounding=0.0001 \
          --family=$name \
	  --fullname=$name \
	  --name=$name $src

mv *.pfb *.tfm *.log ..
cd ..
rm -rf ${tmp}
