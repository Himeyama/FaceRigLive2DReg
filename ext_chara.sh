#!/usr/bin/env bash
# 儚い...

# パスワードを入れて実行する
if [[ "$1" == "" ]]; then
    echo パスワードを入力してください 0>1
    exit 1
else
    unzip -P $1 chara.zip
fi