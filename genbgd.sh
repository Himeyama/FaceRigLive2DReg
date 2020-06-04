#!/usr/bin/env bash

for f in `ls chara`; do
    if [[ -f chara/$f ]]; then
        id=`basename $f .png`
        ./bgd.rb live2d/chara/$id chara/$f
    fi
done