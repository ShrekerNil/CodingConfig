#!/bin/sh  
#============ get the file name ===========
cur_dir="$( cd "$( dirname "$0"  )" && pwd )"
for file in ${cur_dir}/*; do
  if test -d $file ; then
    echo FOUND DIR: `basename $file`
    for proj in ${file}/*; do
      if test -d $proj ; then
        echo FOUND PROJ: `basename $proj`
        if [ -d "${proj}/.git" ]; then
            echo PULLING Git Repo: $proj
            cd $proj
            git pull
        fi
      fi
    done
  else
    echo FOUND FILE: `basename $file`
  fi
done
