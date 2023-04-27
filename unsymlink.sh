#!/bin/bash
dotfilesDir=$(pwd)
cd
for dotfileLink in .*; do
    test -L || continue
    target="$(readlink "$dotfileLink")"
    if [[ $target =~ $dotfilesDir/dot/ ]]
    then
       echo "removed symlink from $dotfileLink to $target"
       rm "$dotfileLink"
    fi
done
