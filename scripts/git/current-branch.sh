#! /bin/bash

if [ -n "$2" ]; then

currentBranch=$1
echo "Current branch is $currentBranch"

else

currentBranch=$(git branch | awk '/\*/ { print $2; }')
# 另一种获取当前 branch_name 的方法
# git symbolic-ref --short HEAD
echo "current branch is ${currentBranch}"

fi
