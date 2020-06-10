#!/usr/bin/env bash

for f in `ls chara`; do
    if [[ -f chara/$f ]]; then
        skip=false
        id=`basename $f .png`
        skip_list=`cat chara/.skip.csv`
        for s in $skip_list; do
            if [[ "$s" == "$id" ]]; then
                skip=true
                break
            fi
        done

        if $skip; then
            echo -e "\033[31m[無視]\033[0m $id"
        else
            echo -e "\033[32m[新規]\033[0m $id"
            echo $id >> chara/.skip.csv
            ./bgd.rb live2d/chara/$id chara/$f
        fi
    fi
done