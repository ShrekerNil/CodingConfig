#!/bin/bash

if [ $# -eq 0 ] ; then
  echo "error : there is no para"
  exit 1
fi

if [ ! -e $1 ] ; then
  echo "file $1 is not exist"
  exit 1
fi

last2=$(tail -c 2 "$1" | od -x -A n)

if [ $last2 = 0a0d -o $last2 = 0d0a ] ; then
  echo "end with \\r\\n"
else
  echo "end with \\n"
fi
