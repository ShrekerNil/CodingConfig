#!/bin/bash

CUR_FOLDER="$( cd "$( dirname "$0"  )" && pwd )"

echo "CUR_FOLDER: "$CUR_FOLDER

while read line || [[ -n ${line} ]]
do
  echo "Handling: "$line
  dos2unix $line
done < $CUR_FOLDER/dos-to-unix-paths.txt

read -p "Processing Completed, PRESSING ENTER TO EXIT ... "
