#!/bin/sh  
#============ get the file name ===========

function new_line() {
  echo -e "\n"
}

cur_dir="$( cd "$( dirname "$0"  )" && pwd  )"

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo PULLING : $cur_dir
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
cd $cur_dir
git pull

for sub_folder in ${cur_dir}/*; do
  if test -d $sub_folder ; then
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    echo FOUND sub_folder: `basename $sub_folder`
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    if [ -d "${sub_folder}/.git" ]; then
        echo "---------------------------------------------------------"
        echo PULLING Git Repo: $sub_folder
        echo "---------------------------------------------------------"
        cd $sub_folder
        git pull
    fi
    new_line
  fi
done

read -p "PRESSING ENTER TO EXIT ... "
