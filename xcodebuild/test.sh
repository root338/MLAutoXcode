#!/bin/sh
echo "'$0': $0"
echo "'$BASH_SOURCE': $BASH_SOURCE"
echo "'${BASH_SOURCE[0]}': ${BASH_SOURCE[0]}"
mPath=$0
echo "'$0': ${mPath##*/} "
echo "'basename $0': $(basename ${mPath})"


echo "'dirname $0': $(dirname ${mPath})"
