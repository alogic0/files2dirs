#!/bin/bash

source="$(pwd)"/orig
dest="$(pwd)"/dest
topfl=cataloguef7eb.html

ext_file () { 
   lnk=$(echo "$1" | sed -r 's@^.*<a href="@@; s@".*$@@; s@\?.*$@@')
   echo $(basename "$lnk")
}

ext_dir () {
   echo "$1" | sed -r 's@^.*<a href="[^"]+"> *@@; s@ *</a>.*$@@; 
                       s@\&#x00a0;|\&#xe802;@ @g;
                       s@<.*sup>|<.*strong>|<.*span>|<.*b>|\&#x00ae;|\&amp;|#x00fc;@@g;
                       s@/@,@g;'
}

f_tree () {
  sed -r 's@(<h4>)@\n\1@; s@(</h4>)@\1\n@' "$1" | grep '<h4' | while read s; do
      fl=$(ext_file "$s")
      if [ -f $source/$fl ]; then
        dir_n="$(ext_dir "$s")"
        if [ ! -d "$dir_n" ]; then
          mkdir "$dir_n" || echo "Error: $fl $dir_n"
        fi
        cp $source/$fl "$dir_n"
        pushd "$dir_n" >/dev/null
        f_tree $fl
        popd >/dev/null
      fi
  done
}

cp $source/$topfl $dest
cd $dest
f_tree $topfl
