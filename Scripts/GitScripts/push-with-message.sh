#!/bin/bash

function judgement(){
  if [[ $2 -eq 0 ]]; then
    echo $1 "EXECUTED SUCCESSFULLY."
  else
    if [[ $2 -eq 1 ]]; then
      echo "ERROR: 通用未知错误"
    elif [[ $2 -eq 2 ]]; then
      echo "ERROR: 误用shell命令"
    elif [[ $2 -eq 126 ]]; then
      echo "ERROR: 命令不可执行"
    elif [[ $2 -eq 127 ]]; then
      echo "ERROR: 没找到命令"
    elif [[ $2 -eq 128 ]]; then
      echo "ERROR: 无效退出参数"
    elif [[ $2 -eq '128+x Linux' ]]; then
      echo "ERROR: 信号x的严重错误"
    elif [[ $2 -eq '128+x' ]]; then
      echo "ERROR: Linux 信号2 的严重错误，即命令通过SIGINT（Ctrl＋Ｃ）终止"
    elif [[ $2 -eq '255' ]]; then
      echo "ERROR: 退出状态码越界"
    else
      echo "UNEXPECTED CODE: "$2
    fi
    echo $1 "EXECUTED FAILURE."
    read -p "PRESSING ENTER TO EXIT ... "
    exit $2
  fi
}

read -p "PLEASE ENTER THE MESSAGE: " message
while [ ! $message ]
do
read -p "PLEASE ENTER THE MESSAGE: " message
done

function printStartLine() {
  echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
}

function printEndLine() {
  echo ----------------------
}

echo -e "\033]0;BackUp files\007"
printStartLine
echo Changing Directory to Current: `pwd`
#DIR_ROOT=`git rev-parse --show-toplevel`
#echo Changing Directory to Current: `DIR_ROOT`
printEndLine
cd `pwd`
judgement "cd `pwd`" $?

echo -e "\n"
printStartLine
echo Getting And Listing Status Before Update...
printEndLine
git status
judgement "git status" $?

echo -e "\n"
printStartLine
echo Adding new Code...
printEndLine
git add ./
judgement "git add" $?

echo -e "\n"
printStartLine
echo Commiting New Change to Local Repository...
printEndLine
#git commit -m "<<Auto Save Files>>"
git commit -m message
judgement "git commit" $?

echo -e "\n"
printStartLine
echo Pulling New Code...
printEndLine
git pull
judgement "git pull" $?

echo -e "\n"
printStartLine
echo Pushing Local Ropository to Remote Repository...
printEndLine
git push -u origin master
judgement "git push" $?

echo -e "\n"
read -p "PRESSING ENTER TO EXIT ... "

