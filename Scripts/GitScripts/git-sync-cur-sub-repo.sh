#!/bin/sh  
#============ get the file name ===========

function new_line() {
  echo -e "\n"
}

cur_dir="$( cd "$( dirname "$0"  )" && pwd )"

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo START SYNCHRONIZING DIRECTORY: $cur_dir
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
cd $cur_dir

for sub_dir in ${cur_dir}/*; do
  if test -d $sub_dir ; then
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    echo FOUND sub_dir: `basename $sub_dir`
    cd $sub_dir
    if [ -d "${sub_dir}/.git" ]; then
        if [ -f "git-sync.sh" ]; then
            echo "--------------------------------------------------"
            echo SYNCHRONIZING Git Repo: $sub_dir
            bash git-sync.sh
            continue
        else
            echo "This is a Git repo, but there's no file: git-sync.sh"
        fi
    else
        echo "This is not a repo ..."
    fi
    new_line
  fi
done

echo "All Work Done!"

read -p "PRESSING ENTER TO EXIT ... "
