#!/bin/bash

#func check CRLF
check_CRLF(){
  last2=$(tail -c 2 "$1" | od -x -A n)
  echo "last2 is $last2"
  if [ $last2 = 0a0d -o $last2 = 0d0a ] ; then
    echo "warning! file $1 end with \\r\\n"
  else
    echo "file $1 end with \\n"
  fi
}

#func iterate folder
iterate_folder(){
  # no para
  if [ $# -eq 0 ]; then
    exit 1
  fi

  # not folder
  if [ ! -d $1 ]; then
    exit 1
  fi

  # traversal
  for files_or_folder in $1/*
  do
  if [ -f "$files_or_folder" ]; then
    # is file
    check_CRLF "$files_or_folder"
  elif [ -d "$files_or_folder" ]; then
    # is folder
    iterate_folder "$files_or_folder"
  else
    exit 1
  fi
  done
}

if [ $# -eq 0 ] ; then
  echo "error : there is no para"
  exit 1
fi

iterate_folder $1

#iterate_folder /d/GitRepo/GitEE/QLNotes/Config/Git
