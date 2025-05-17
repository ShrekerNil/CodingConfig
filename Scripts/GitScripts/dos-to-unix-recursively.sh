#!/bin/bash

# This is the place that need you to modify!!!!!
TARGET_FOLDER="C:\Users\Shreker\AppData\Roaming\Typora"

TEXT_EXTS=(txt sh md ini pub json css)

CUR_FOLDER="$( cd "$( dirname "$0" )" && pwd )"

echo "CUR_FOLDER: "$CUR_FOLDER

IFS_BACKUP=$IFS
IFS=$(echo -en "\n\b")

recursive_dir(){
  for file in `ls $1`
  do
    cur_file=$1"/"$file
    if [ -d $cur_file ]
    then
      if [[ $file != '.' && $file != '..' ]]
      then
          recursive_dir $cur_file
      fi
    else
      echo "****************** Find file: $cur_file ********************"
      cur_ext="${cur_file##*.}"
      if [[ "${TEXT_EXTS[@]}" =~ "${cur_ext}" ]];then
        line_ending=`tail -c 2 $cur_file | od -x -A n`
        echo "line_ending code: "$line_ending
        dos2unix $cur_file
      fi
    fi
  done
}

recursive_dir $TARGET_FOLDER

IFS=$IFS_BACKUP

read -p "Processing Completed, PRESSING ENTER TO EXIT ... "
