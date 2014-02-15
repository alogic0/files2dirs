#!/bin/bash

source="$(pwd)"/orig
dest="$(pwd)"/dest

ext_file () { 
   lnk=$(echo "$1" | sed -r 's@^.*<a href="@@' | sed -r 's@".*$@@')
   echo $(basename "$lnk")
}

ext_dir () {
   echo "$1" | sed -r 's@^.*<a href="[^"]+"> *@@' | sed -r 's@ *<.*$@@'
}

f_tree () {
  sed -r 's@(<h4>)@\n\1@; s@(</h4>)@\1\n@' "$1" | grep '<h4' | while read s; do
      fl=$(ext_file "$s")
      if [ -f $source/$fl ]; then
        dir_n="$(ext_dir "$s")"
        mkdir "$dir_n"
        cp $source/$fl "$dir_n"
        pushd "$dir_n" >/dev/null
        f_tree $fl
        popd >/dev/null
      fi
  done
}

cp $source/catalogueabcd.html $dest
cd $dest
f_tree catalogueabcd.html
