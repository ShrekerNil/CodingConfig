#!/usr/bin/env bash

BASE_DIR=$(pwd -P)

for file in $(ls); do
if [[ -d $file ]] && [[ -d $file/.git ]]; then
  echo ====================================================================
  cd $file
  
  if branch=$(git symbolic-ref --short -q HEAD)
  then
    echo Current branch: $branch
  else
    echo Not on any valid branch. Skipping ...
    continue
  fi
  
  echo --- Start Force Reset $(pwd) ---
  git reset --hard origin/$branch
  
  echo --- Start Force checkout $(pwd) ---
  git checkout -f $(pwd)
  
  echo --- Start Pulling $file ---
  git pull
  
  if [[ $file == "orms" || $file == "orms/" ]]; then
    echo --- Start Recovery 'orms.properties' ---
    git stash apply
  fi
  
  cd $BASE_DIR
  
  echo --- Pulling $file Finished ---
  echo ------------------------------------
fi
done

read -p "PRESS 'ENTER' TO CONTINUE ... "
