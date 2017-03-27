#!/bin/bash
#
# Copyright 2017, akashche at redhat.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e
set -x

if [ ! -d "$1" ] ; then
    echo "RPM repo not specified"
    exit 1
fi

RPMREPO_DIR=$1

RPMNAME="$( basename $RPMREPO_DIR )"
OUT_FILE=$RPMNAME-patches.sh

grep ^Patch $RPMREPO_DIR/SPECS/$RPMNAME.spec | awk '{print substr($1, 6) " " $2}' > patches-decl.txt
grep %patch $RPMREPO_DIR/SPECS/$RPMNAME.spec | awk '{print substr($1, 7) ": " $2}' > patches-impl.txt


echo "# $( date +%Y-%m-%d_%H:%M:%S )" > $OUT_FILE
echo "# RPMREPO_DIR: $RPMREPO_DIR" >> $OUT_FILE
echo "" >> $OUT_FILE
echo "set -e" >> $OUT_FILE
echo "set -x" >> $OUT_FILE

while read line ; do 
    num="$( echo $line | awk '{ print $1 }' )"
    plevel="$( echo $line | awk '{ print $2 }' )"
    patchfile="$( grep ^$num patches-decl.txt | awk '{ print $2 }' )"
    patchname="$( echo $patchfile | sed 's/\.patch//' )"
    echo "" >> $OUT_FILE
    echo "echo $num $patchname" >> $OUT_FILE
    echo "patch $plevel < $RPMREPO_DIR/SOURCES/$patchfile" >> $OUT_FILE
    echo "find . -name "*.orig" -type f -delete" >> $OUT_FILE
    echo "git add *" >> $OUT_FILE
    echo "git commit -am \"apply $patchname\"" >> $OUT_FILE
done < patches-impl.txt
