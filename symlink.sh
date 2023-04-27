#!/bin/bash
shopt -s dotglob
echo $(pwd)
cd dot
for file in *; do
     echo "symlinking $file"
     ln -sf "$(pwd)/$file" ~/"$file"
done
