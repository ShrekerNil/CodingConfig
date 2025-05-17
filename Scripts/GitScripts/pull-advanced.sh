#!/usr/bin/env bash

BASE_DIR=$(pwd -P)

for file in $(ls); do
if [[ -d $file ]] && [[ -d $file/.git ]]; then
  echo ====================================================================
  echo Start Pulling $file ...
  if [[ $file == "ormsui" || $file == "ormsui/" ]]; then
    MASTER_DIR=$(pwd)
    echo "GOT WHAT I WANT ..."
    source /d/Repositories/GitEE/QLNotes/Scripts/Linux/General/CopyFiles.sh 1 1
    cd $MASTER_DIR
  fi
  
  cd $file
  git pull origin master
  
  if [[ $file == "ormsui" || $file == "ormsui/" ]]; then
    echo "GOT WHAT I WANT ..."
    source /d/Repositories/GitEE/QLNotes/Scripts/Linux/General/CopyFiles.sh 2 1
  fi
  
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
